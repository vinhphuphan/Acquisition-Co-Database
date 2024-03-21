-- ----------------------------------------------------------------
-- Function 1
-- A function created to work out how much annual leave someone
-- should get for the hours they have worked. Someone working a 
-- full year should get 4 weeks annual leave. This function should
-- only work with positive numbers. A negative number of hours
-- worked should result in 0 annual leave hours being output.

-- The calculation: assuming numberOfHoursWorked is positive, then
-- the annual leave should be calculated by taking the hours worked
-- and dividing it by 13.035714 ... then rounding up to the nearest
-- 2 decimal places.
-- ----------------------------------------------------------------

DELIMITER //
DROP FUNCTION IF EXISTS calculate_annual_leave;
//

CREATE FUNCTION calculate_annual_leave( numberOfHoursWorked DOUBLE)
	RETURNS DOUBLE -- RETURNS THE NUMBER OF ANNUAL LEAVE HOURS
    DETERMINISTIC
BEGIN
	DECLARE annual_leave_hours INT DEFAULT 0;
    IF numberOfHoursWorked <= 0 THEN
    SET annual_leave_hours = 0;
    ELSE
	SET annual_leave_hours = round(numberOfHoursWorked/13.035714, 2);
    END IF;
    RETURN annual_leave_hours;
END
//
DELIMITER ;


-- ----------------------------------------------------------------
-- Function 2
-- A function created to work out how much your staff at Acqisition
-- Co should receive in the currenr financial year. For the moment
-- we will hard code the tax values rather than relying on database
-- values from a table.
-- What this needs to do: (note, this is a fictional calculation
-- and does not actually reflect the Australia Tax rates)
-- There are rates of tax to apply (on a per-week basis)
-- if someone earns $X per week, then the tax withheld is some 
-- % of that amount. The details are below
-- given $ per week as income 0 the base tax withheld is:
--   $ between 0 and $300 per week -> no tax withheld
-- 	 $ between $300 and  $800      -> (($ - 300) * 0.15)
-- 	 $ between $800 and  $2300     -> 152 + (($ - 800) * 0.3)
--   $ between $2300 and $3500     -> 602 + (($ - 2300) * 0.375)
--   $ is over $3500 per week      -> ($ - 1142) * 0.45
-- 
-- if is_claiming_tax_free_threshhold is set to FALSE, then you
-- will need to multiply the number you get above by 1.2
-- 
-- then multiply the number by the number of weeks being calculated
--
-- note that the total_pay_before_tax will need to be divided by
-- the number of weeks before doing any of the above calculations.
-- ----------------------------------------------------------------
DELIMITER //
DROP FUNCTION IF EXISTS calculate_basic_tax_withheld_amount;
//

CREATE FUNCTION calculate_basic_tax_withheld_amount(
		total_pay_before_tax DOUBLE,
        number_of_weeks INT,
        is_claiming_tax_free_threshhold BOOLEAN
	)
    RETURNS DOUBLE -- tax_withheld_amount
    DETERMINISTIC
BEGIN
	DECLARE tax_withheld_amount DOUBLE;
    DECLARE income_per_week DOUBLE DEFAULT 0;
    SET income_per_week = total_pay_before_tax/number_of_weeks;
    CASE
		WHEN income_per_week > 0 AND income_per_week <= 300 THEN SET tax_withheld_amount = 0;
        WHEN income_per_week > 300 AND income_per_week <= 800 THEN SET tax_withheld_amount = ((income_per_week - 300) * 0.15);
        WHEN income_per_week > 800 AND income_per_week <= 2300 THEN SET tax_withheld_amount = 152 + ((income_per_week - 800) * 0.3);
        WHEN income_per_week > 2300 AND income_per_week <= 3500 THEN SET tax_withheld_amount = 602 + ((income_per_week - 2300) * 0.375);
		WHEN income_per_week > 3500  THEN SET tax_withheld_amount = (income_per_week - 1142) * 0.45;
        ELSE BEGIN END;
    END CASE;
    IF is_claiming_tax_free_threshhold = FALSE THEN
    SET tax_withheld_amount = tax_withheld_amount * 1.2;
    END IF;
    RETURN tax_withheld_amount*number_of_weeks;
END
//
DELIMITER ;

-- ----------------------------------------------------------------
-- Function 3
-- Sick leave at Acquisition Co is calculated based on a certain 
-- value... but what we would like you to do is to use your 
-- calculate_annual_leave function and use that value for 
-- your calcualtion in this function. The calucaltion will 
-- be 75.5% of the annual leave value that is generated.
-- ----------------------------------------------------------------
DELIMITER //
DROP FUNCTION IF EXISTS calculate_sick_leave;
//

CREATE FUNCTION calculate_sick_leave(numberOfHoursWorked DOUBLE)
	RETURNS DOUBLE -- sick_leave_hours
    DETERMINISTIC
BEGIN
	DECLARE sick_leave DOUBLE DEFAULT 0;
    DECLARE annual_leave DOUBLE DEFAULT 0;
    SELECT calculate_annual_leave(numberOfHoursWorked) INTO annual_leave;
    SET sick_leave = annual_leave* 0.755;
    RETURN sick_leave;
END
//

DELIMITER ;







-- ----------------------------------------------------------------
-- Optional Bonus Stored Procedure 
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

