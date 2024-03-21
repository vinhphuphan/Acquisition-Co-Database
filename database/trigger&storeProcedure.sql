-- ----------------------------------------------------------------
-- Trigger and Store Procedures for enforce constraints and provide 
-- functionality for managing enrolments, calculating staff payments, 
-- and generating payment summaries within an acquisition company's database.
-- ----------------------------------------------------------------

-- ----------------------------------------------------------------
-- Trigger 1 :  this trigger ensures that no more enrolments are allowed
-- for a training session once the maximum number of attendees has been reached. 
-- It prevents overbooking and helps maintain the integrity of the training session attendance limit. 
-- ----------------------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS training_session_is_full 
//
CREATE TRIGGER training_session_is_full 
 	BEFORE INSERT ON acq_training_enrolment
	FOR EACH ROW
BEGIN
	DECLARE max_number_of_attendees INT;
    DECLARE curr_num_of_enrolments INT;
    DECLARE msg VARCHAR(255);
    -- Select the max attendees
    SELECT DISTINCT(a1.max_number_of_attendees) INTO max_number_of_attendees
    FROM acq_training_course_session a1 JOIN acq_training_enrolment USING (training_course_session_id)
    WHERE a1.training_course_session_id = NEW.training_course_session_id;
    -- Count the current number of enrolments
    SELECT COUNT(*) INTO curr_num_of_enrolments
    FROM acq_training_enrolment
    WHERE training_course_session_id = NEW.training_course_session_id;
	-- Compare them
	IF curr_num_of_enrolments = max_number_of_attendees THEN 
	SET msg = "Training Session Is Full";
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
	END IF;
END
//    
DELIMITER ;

-- ----------------------------------------------------------------
-- Store Procedure 1 :  
-- the stored procedure should take a staff ID and enrol them in
-- the desired course ID. The output should be the enrolment number
-- if the action is successful, or -1 if the action was not possible
-- (e.g. 
--     - because the staff ID didn't exists, 
--     - because the the course id didn't exist,
--     - beacuse the number of spots is full.
--     - or because the staff member already enrolled in that 
--       course in the same calendar year as that course already.
--  
-- ----------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS enrol_staff_in_training_course;
//

CREATE PROCEDURE enrol_staff_in_training_course(
		IN staffID INT,
        IN course_id INT,
        OUT enrolment_id INT
	)
BEGIN
	DECLARE generate_new_enrol_id INT DEFAULT 0;
    DECLARE find INT DEFAULT 0;
	DECLARE has_error INT DEFAULT 0;
    DECLARE full_slot INT DEFAULT 0;
    DECLARE fullspots CONDITION FOR SQLSTATE '45000'; 
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET has_error = 1; 
    DECLARE CONTINUE HANDLER FOR fullspots SET full_slot = 1;
    -- Check whether staffId and course_id exist in table or not
    SELECT DISTINCT training_enrolment_id INTO find
    FROM acq_training_enrolment 
    WHERE acq_staff_acq_person_id = staffID AND training_course_session_id = course_id;
    
	IF (find != 0) OR (has_error = 1) OR (full_slot = 1) OR (staffID is null) OR (course_id is null) THEN
		SET generate_new_enrol_id = -1;
		SELECT generate_new_enrol_id INTO enrolment_id;
    ELSE
		-- Count the number of rows and add 1 to generate the new enrol_id
		SET generate_new_enrol_id = (SELECT COUNT(*) FROM acq_training_enrolment) + 1 ;
		-- Insert values to table
		INSERT INTO acq_training_enrolment(training_enrolment_id, training_course_session_id, acq_staff_acq_person_id, training_completed, comment)
		VALUES (generate_new_enrol_id, course_id, staffID, 0, 'No Comment');
		
		SELECT generate_new_enrol_id INTO enrolment_id;
	END IF;
END
//    
DELIMITER ;

-- ----------------------------------------------------------------
-- Store Procedure 2 : staff who have worked across the most stores 
-- for a time period (timesheet + contracts).
-- return staff Name, staff id, and number of different stores a staff
-- member has worked at during that time. This is not the number of
-- stores for 1 company, but across ALL Acquisition Co companies.
-- ----------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS staff_report_5;
//

DELIMITER //
DROP PROCEDURE IF EXISTS staff_report_5;
//
CREATE PROCEDURE staff_report_5(
		IN staff_id INT,
		IN date_from_inclusive DATE,
       		IN date_to_inclusive DATE
	)
BEGIN
	DECLARE staff_name VARCHAR(50);
   	DECLARE num_stores INT DEFAULT 0;
	DECLARE count_ft, count_pt,count_casual_stores INT DEFAULT 0;
	
-- Select the staff name
	SELECT CONCAT(salutation,' ',family_name,' ',given_names) INTO staff_name
	FROM acq_staff
	WHERE acq_staff.acq_person_id = staff_id;

-- Select the number of full-time contract in given time
	SELECT COUNT(*) INTO count_ft
	FROM acq_contract
	JOIN acq_ft_contract ON acq_contract.acq_contract_id = acq_ft_contract.acq_contract_acq_contract_id
	WHERE acq_contract.acq_staff_acq_person_id = staff_id
    AND acq_contract.start_date >= date_from_inclusive 
    AND acq_contract.end_date <= date_to_inclusive;

-- Select the number of part-time contract in given time
	SELECT COUNT(*) INTO count_pt
	FROM acq_contract
	JOIN acq_pt_contract ON acq_contract.acq_contract_id = acq_pt_contract.acq_contract_acq_contract_id
	WHERE acq_contract.acq_staff_acq_person_id = staff_id
    AND acq_contract.start_date >= date_from_inclusive 
    AND acq_contract.end_date <= date_to_inclusive;
    	
	-- Handle the casual contract – count the stores of casual timesheet
	SELECT COUNT(DISTINCT(acq_store_id)) INTO count_casual_stores
	FROM
		(SELECT start_date, end_date, acq_contract_id
		FROM acq_contract
		WHERE acq_contract.acq_staff_acq_person_id = staff_id)   t1
		
		JOIN
		
		(SELECT acq_timesheet.acq_store_id, casual_for_stores.casual_contract_id
		FROM acq_timesheet JOIN casual_for_stores
		ON acq_timesheet.acq_store_id = casual_for_stores.acq_store_id 
		AND acq_timesheet.casual_contract_id = casual_for_stores.casual_contract_id)   t2
		
		ON t1.acq_contract_id = t2.casual_contract_id
		
	WHERE t1.start_date >= date_from_inclusive AND t1.end_date <= date_to_inclusive;
    	
	SET num_stores = num_stores + count_casual_stores + count_ft + count_pt;
	SELECT CONCAT(staff_name, ' has worked at ', num_stores, ' different stores') as 'Output'; 
END
//  
-- DELIMITER ;


-- -- ----------------------------------------------------------------
-- -- Store Procedure 3
-- -- Reading all casual timesheet entries for a selected staff member for a period of time.
-- -- ----------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS total_casual_pay_for_staff_member;
//

CREATE PROCEDURE total_casual_pay_for_staff_member(
		IN date_from_inclusive DATE,
        IN date_to_inclusive DATE,
        IN staff_id INT,
        OUT total_casual_amount_before_tax DOUBLE
	)
BEGIN
	DECLARE v_pay_amount_per_timesheet DOUBLE DEFAULT 0;
    DECLARE v_finished INT DEFAULT 0;
    DECLARE total_pay DOUBLE DEFAULT 0;
    -- Create a cursor to store the payment per week
    DECLARE timesheet_rec CURSOR FOR
				SELECT acq_timesheet.number_of_hours*acq_timesheet.pay_rate
				FROM acq_timesheet 
				JOIN acq_contract
				ON acq_timesheet.casual_contract_id = acq_contract.acq_contract_id
				JOIN acq_casual_contract
				ON acq_casual_contract.acq_contract_acq_contract_id = acq_contract.acq_contract_id
				WHERE acq_contract.acq_staff_acq_person_id = staff_id
				AND acq_contract.start_date >= date_from_inclusive AND acq_contract.end_date <= date_to_inclusive;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
    
    OPEN timesheet_rec;
    REPEAT
		FETCH timesheet_rec INTO v_pay_amount_per_timesheet;
        IF not(v_finished = 1) THEN
			-- calculate the total pay
			SET total_pay = total_pay + v_pay_amount_per_timesheet;
		END IF;
        UNTIL v_finished
	END REPEAT;
    CLOSE timesheet_rec;
    
    SELECT ROUND(total_pay,2) INTO total_casual_amount_before_tax;
END
//  
DELIMITER ;

-- -- ----------------------------------------------------------------
-- -- Store Procedure 4
-- -- Reading all manager, full time, and part time contracts for a 
-- -- selected staff member for a period of time.
-- -- ----------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS total_noncasual_pay_for_staff_member;
//

CREATE PROCEDURE total_noncasual_pay_for_staff_member(
		IN date_from_inclusive DATE,
        IN date_to_inclusive DATE,
        IN staff_id INT,
        OUT total_noncasual_amount_before_tax DOUBLE
	)
BEGIN
	DECLARE ft_contract_total_pay DOUBLE DEFAULT 0;
    DECLARE pt_contract_total_pay DOUBLE DEFAULT 0;
    DECLARE total_pay DOUBLE DEFAULT 0;
    DECLARE v_finished1, v_finished2 INT DEFAULT 0;
    -- Create a cursor to store salary of full-time staff - searched by staff-id
	DECLARE ft_contract_rec CURSOR FOR
			SELECT (salary/52)
			FROM acq_ft_contract
			WHERE acq_ft_contract.acq_contract_acq_contract_id IN
			(SELECT acq_contract_id
			FROM acq_contract
			WHERE acq_staff_acq_person_id = staff_id
			AND contract_type LIKE ('ft') 
			AND start_date >= date_from_inclusive AND end_date <= date_to_inclusive);
    
    -- Create another cursor to store salary of part-time staff - searched by staff-id    
	DECLARE pt_contract_rec CURSOR FOR
			SELECT acq_pt_contract.hourly_rate*acq_pt_contract.pt_hours_per_week
			FROM acq_pt_contract
			WHERE acq_pt_contract.acq_contract_acq_contract_id IN
			(SELECT acq_contract_id
			FROM acq_contract
			WHERE acq_contract.acq_staff_acq_person_id = staff_id
			AND contract_type LIKE ('pf')
			AND start_date >= date_from_inclusive AND end_date <= date_to_inclusive);
	
		BEGIN
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished1 = 1;
			OPEN ft_contract_rec;
			REPEAT
				FETCH ft_contract_rec INTO ft_contract_total_pay;
				IF not(v_finished1 = 1) THEN
					SET total_pay = total_pay + ft_contract_total_pay;
				END IF;
				UNTIL v_finished1
			END REPEAT;
			CLOSE ft_contract_rec;
		END;
        
		BEGIN
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished2 = 1;
			OPEN pt_contract_rec;
			REPEAT
			FETCH pt_contract_rec INTO pt_contract_total_pay;
				IF not(v_finished2 = 1) THEN
					SET total_pay = total_pay + pt_contract_total_pay;
				END IF;
				UNTIL v_finished2
			END REPEAT;
			CLOSE pt_contract_rec;
		END;
		
        SELECT ROUND(total_pay,2) INTO total_noncasual_amount_before_tax;
    
END
//  
DELIMITER ;


-- ----------------------------------------------------------------
-- Store Procedure 5
-- generate a basic pay slip for an employee (across all their work in acquisition co).
-- The process:
-- For a staff member, get their total casual pay, their total pay
-- from other contracts, and then get ready to generate a pay slip.
--
-- Pay slips are generated for a 2-week period starting on a Monday
-- Monday , Tuesday, ..., Sunday, Monday, .... Sunday.
--
-- If the monday_date given is NOT a monday, then the rest of the 
-- stored procedure should not run, and the payslip ID should be 
-- set to -1
--
-- Given a staff number and a date for a Monday, this stored 
-- procedure should gather total amount to be paid for all casual,
-- full time, and part time work that has been taken during the
-- two week period starting from the Monday date. 
--
-- Then, calculate the tax $ to be withheld based on if the staff
-- member record indicates they do or do not want to claim the tax
-- free threshhold. 
--
-- Then, create a new payslip indication entry for this staff member
-- with the amount earned before tax, then amount of tax to be 
-- withheld, and the amount that will go into their bank account.
--
-- ----------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS generate_staff_payslip_indication;
//

CREATE PROCEDURE generate_staff_payslip_indication(
		IN monday_date DATE,
        IN staff_id INT,
        OUT payslip_indication_id INT,
        OUT total_gross_pay DOUBLE,
        OUT total_tax_withheld DOUBLE,
        OUT total_net_pay DOUBLE
	)
BEGIN
	DECLARE total_pay_casual_per_week DOUBLE DEFAULT 0;
    DECLARE total_pay_noncasual DOUBLE DEFAULT 0;
    DECLARE gross_pay DOUBLE DEFAULT 0;
	DECLARE tax DOUBLE DEFAULT 0;
    DECLARE net_pay DOUBLE DEFAULT 0;
    DECLARE tax_free_threshhold_or_not INT DEFAULT 0;
    DECLARE generate_new_payslip_id INT DEFAULT 0;
    -- Condition check if the given date is monday
    IF WEEKDAY(monday_date) != 0  THEN
		SET generate_new_payslip_id = -1;
		SELECT generate_new_payslip_id INTO payslip_indication_id;
    ELSE
		-- Call the procedure to calculate the total pay for casual staff 
		CALL total_casual_pay_for_staff_member(monday_date, DATE_ADD(monday_date,INTERVAL 13 DAY),staff_id, @total_casual);
        SELECT @total_casual INTO total_pay_casual_per_week;
        -- Call the procedure to calculate the total pay for casual staff
        CALL total_noncasual_pay_for_staff_member(monday_date, DATE_ADD(monday_date,INTERVAL 13 DAY),staff_id, @total_noncasual);
        SELECT @total_noncasual INTO total_pay_noncasual;
        -- Calculate Gross Pay
        SET gross_pay = total_pay_casual_per_week*2 + total_pay_noncasual*2;
        -- Check whether free theshhold or not
        SELECT claiming_tax_free_threshhold INTO tax_free_threshhold_or_not
 		FROM acq_staff
		WHERE acq_person_id = staff_id;
         -- Use the function to calculate the tax
		SELECT calculate_basic_tax_withheld_amount(gross_pay, 2, tax_free_threshhold_or_not) INTO tax; 
	
        SET net_pay = gross_pay - tax;
        
        SET generate_new_payslip_id = (SELECT COUNT(*) FROM acq_payslip_indication) + 1;
        -- Insert values into the acq_payslip_indication table
        INSERT INTO acq_payslip_indication 
        VALUES(generate_new_payslip_id, monday_date, net_pay, gross_pay, tax, staff_id);
	END IF;
	SELECT generate_new_payslip_id INTO payslip_indication_id;
    SELECT ROUND(gross_pay,2) INTO total_gross_pay;
    SELECT ROUND(tax,2) INTO total_tax_withheld;
	SELECT ROUND(net_pay,2) INTO total_net_pay;
END
//  
DELIMITER ;

-- ----------------------------------------------------------------
-- Stored Procedure 6 : 
-- Generating staff payment summary for a financial year
-- ----------------------------------------------------------------

DELIMITER //

DROP PROCEDURE IF EXISTS generate_basic_pay_summary_indication;
//
-- This procedure has the same logic with the previous one - The only difference is the time range.
CREATE PROCEDURE generate_basic_pay_summary_indication(
		IN monday_date DATE,
        IN number_of_weeks INT,
        IN staff_id INT,
        OUT total_gross_pay DOUBLE,
        OUT total_tax_withheld DOUBLE,
        OUT total_net_pay DOUBLE
	)
BEGIN
	DECLARE total_pay_casual_per_week DOUBLE DEFAULT 0;
    DECLARE total_pay_noncasual DOUBLE DEFAULT 0;
    DECLARE gross_pay DOUBLE DEFAULT 0;
	DECLARE tax DOUBLE DEFAULT 0;
    DECLARE net_pay DOUBLE DEFAULT 0;
    DECLARE tax_free_threshhold_or_not INT DEFAULT 0;
    DECLARE check_monday INT DEFAULT 0;
    
    IF WEEKDAY(monday_date) != 0  THEN
		SET check_monday = -1;
		SELECT check_monday As 'Output';
    ELSE
		CALL total_casual_pay_for_staff_member(monday_date, DATE_ADD(monday_date,INTERVAL (number_of_weeks*7) DAY)
        ,staff_id, @total_casual);
        SELECT @total_casual INTO total_pay_casual_per_week;
        
        CALL total_noncasual_pay_for_staff_member(monday_date, DATE_ADD(monday_date,INTERVAL (number_of_weeks*7) DAY)
        ,staff_id, @total_noncasual);
        SELECT @total_noncasual INTO total_pay_noncasual;
        
        SET gross_pay = total_pay_casual_per_week*number_of_weeks + total_pay_noncasual*number_of_weeks;
        
        SELECT claiming_tax_free_threshhold INTO tax_free_threshhold_or_not
		FROM acq_staff
        WHERE acq_person_id = staff_id;
        
        SELECT calculate_basic_tax_withheld_amount(gross_pay, number_of_weeks, tax_free_threshhold_or_not) INTO tax;
        
        SET net_pay = gross_pay - tax;
		
	END IF;
    SELECT round(gross_pay,2) INTO total_gross_pay;
    SELECT round(tax,2) INTO total_tax_withheld;
	SELECT round(net_pay,2) INTO total_net_pay;
END
//  
DELIMITER ;


