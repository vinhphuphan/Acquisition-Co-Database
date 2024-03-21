-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


DROP TABLE IF EXISTS `acq_training_enrolment`;
DROP TABLE IF EXISTS `acq_training_course_session`;
DROP TABLE IF EXISTS `acq_training_course`;
DROP TABLE IF EXISTS `staff_manages_store`;
DROP TABLE IF EXISTS `acq_payslip_ft_item`;
DROP TABLE IF EXISTS `acq_ft_contract`;
DROP TABLE IF EXISTS `acq_payslip_pt_item`;
DROP TABLE IF EXISTS `acq_pt_contract`;
DROP TABLE IF EXISTS `acq_payslip_timesheet_item`;
DROP TABLE IF EXISTS `acq_payslip_indication`;
DROP TABLE IF EXISTS `acq_timesheet`;
DROP TABLE IF EXISTS `casual_for_stores`;
DROP TABLE IF EXISTS `acq_casual_contract`;
DROP TABLE IF EXISTS `acq_contract`;
DROP TABLE IF EXISTS `acq_staff`;
DROP TABLE IF EXISTS `acq_store`;
DROP TABLE IF EXISTS `acq_location`;
DROP TABLE IF EXISTS `acq_shopping_centre`;
DROP TABLE IF EXISTS `acq_foodchain_company`;


-- -----------------------------------------------------
-- Table `acq_foodchain_company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_foodchain_company` (
  `acq_company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(200) NOT NULL,
  `purchase_price` DECIMAL NOT NULL,
  `purchase_date` DATE NOT NULL,
  PRIMARY KEY (`acq_company_id`),
  UNIQUE INDEX `company_name_UNIQUE` (`company_name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_shopping_centre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_shopping_centre` (
  `acq_centre_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `security_phone_number` VARCHAR(15) NULL,
  `manager_phone_number` VARCHAR(15) NULL,
  PRIMARY KEY (`acq_centre_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_location` (
  `acq_location_id` INT NOT NULL,
  `sqft_size` DECIMAL NOT NULL,
  `has_seating` TINYINT NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `acq_shopping_centre_acq_centre_id` INT NULL,
  PRIMARY KEY (`acq_location_id`),
  INDEX `fk_acq_location_acq_shopping_centre1_idx` (`acq_shopping_centre_acq_centre_id` ASC),
  CONSTRAINT `fk_acq_location_acq_shopping_centre1`
    FOREIGN KEY (`acq_shopping_centre_acq_centre_id`)
    REFERENCES `acq_shopping_centre` (`acq_centre_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_store` (
  `acq_store_id` INT NOT NULL,
  `company_store_no` VARCHAR(45) NOT NULL,
  `acq_foodchain_company_acq_company_id` INT NOT NULL,
  `acq_location_acq_location_id` INT NOT NULL,
  PRIMARY KEY (`acq_store_id`),
  INDEX `fk_acq_store_acq_foodchain_company_idx` (`acq_foodchain_company_acq_company_id` ASC),
  INDEX `fk_acq_store_acq_location1_idx` (`acq_location_acq_location_id` ASC),
  CONSTRAINT `fk_acq_store_acq_foodchain_company`
    FOREIGN KEY (`acq_foodchain_company_acq_company_id`)
    REFERENCES `acq_foodchain_company` (`acq_company_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_acq_store_acq_location1`
    FOREIGN KEY (`acq_location_acq_location_id`)
    REFERENCES `acq_location` (`acq_location_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_staff` (
  `acq_person_id` INT NOT NULL,
  `family_name` VARCHAR(200) NOT NULL,
  `given_names` VARCHAR(200) NOT NULL,
  `preferred_name` VARCHAR(200) NOT NULL,
  `salutation` VARCHAR(25) NOT NULL,
  `gender` VARCHAR(10) NULL,
  `claiming_tax_free_threshhold` TINYINT NOT NULL,
  PRIMARY KEY (`acq_person_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_contract` (
  `acq_contract_id` INT NOT NULL,
  `company_person_id` VARCHAR(45) NULL,
  `company_contract_id` VARCHAR(45) NOT NULL,
  `acq_staff_acq_person_id` INT NOT NULL,
  `contract_type` ENUM("ft", "pf", "casual") NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  PRIMARY KEY (`acq_contract_id`),
  INDEX `fk_acq_contract_acq_staff1_idx` (`acq_staff_acq_person_id` ASC),
  CONSTRAINT `fk_acq_contract_acq_staff1`
    FOREIGN KEY (`acq_staff_acq_person_id`)
    REFERENCES `acq_staff` (`acq_person_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_casual_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_casual_contract` (
  `acq_contract_acq_contract_id` INT NOT NULL,
  `base_pay_rate` DECIMAL NOT NULL,
  `pay_loading_percentage` DECIMAL NOT NULL,
  PRIMARY KEY (`acq_contract_acq_contract_id`),
  CONSTRAINT `fk_acq_casual_contract_acq_contract1`
    FOREIGN KEY (`acq_contract_acq_contract_id`)
    REFERENCES `acq_contract` (`acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `casual_for_stores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casual_for_stores` (
  `acq_store_id` INT NOT NULL,
  `casual_contract_id` INT NOT NULL,
  PRIMARY KEY (`acq_store_id`, `casual_contract_id`),
  INDEX `fk_table1_acq_casual_contract1_idx` (`casual_contract_id` ASC),
  CONSTRAINT `fk_table1_acq_store1`
    FOREIGN KEY (`acq_store_id`)
    REFERENCES `acq_store` (`acq_store_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_table1_acq_casual_contract1`
    FOREIGN KEY (`casual_contract_id`)
    REFERENCES `acq_casual_contract` (`acq_contract_acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_timesheet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_timesheet` (
  `timesheet_id` INT NOT NULL,
  `acq_store_id` INT NOT NULL,
  `casual_contract_id` INT NOT NULL,
  `number_of_hours` DECIMAL NOT NULL,
  `pay_rate` DECIMAL NOT NULL,
  `date_being_claimed` DATE NOT NULL,
  `comment` VARCHAR(45) NULL,
  INDEX `fk_acq_timesheet_table11_idx` (`acq_store_id` ASC, `casual_contract_id` ASC),
  PRIMARY KEY (`timesheet_id`),
  CONSTRAINT `fk_acq_timesheet_table11`
    FOREIGN KEY (`acq_store_id` , `casual_contract_id`)
    REFERENCES `casual_for_stores` (`acq_store_id` , `casual_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_payslip_indication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_payslip_indication` (
  `payslip_id` INT NOT NULL,
  `monday_starting` DATE NOT NULL,
  `net_pay_amount` DECIMAL NULL,
  `gross_pay_amount` DECIMAL NULL,
  `toal_tax_amount` DECIMAL NULL,
  `acq_staff_acq_person_id` INT NOT NULL,
  PRIMARY KEY (`payslip_id`),
  INDEX `fk_acq_payslip_indication_acq_staff1_idx` (`acq_staff_acq_person_id` ASC),
  CONSTRAINT `fk_acq_payslip_indication_acq_staff1`
    FOREIGN KEY (`acq_staff_acq_person_id`)
    REFERENCES `acq_staff` (`acq_person_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_payslip_timesheet_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_payslip_timesheet_item` (
  `payslip_id` INT NOT NULL,
  `acq_timesheet_timesheet_id` INT NOT NULL,
  `number_of_hours` DECIMAL NOT NULL,
  `pay_subtotal` DECIMAL NOT NULL,
  PRIMARY KEY (`payslip_id`, `acq_timesheet_timesheet_id`),
  INDEX `fk_acq_payslip_timesheet_item_acq_timesheet1_idx` (`acq_timesheet_timesheet_id` ASC),
  CONSTRAINT `fk_acq_payslip_timesheet_item_acq_payslip_indication1`
    FOREIGN KEY (`payslip_id`)
    REFERENCES `acq_payslip_indication` (`payslip_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_acq_payslip_timesheet_item_acq_timesheet1`
    FOREIGN KEY (`acq_timesheet_timesheet_id`)
    REFERENCES `acq_timesheet` (`timesheet_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_pt_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_pt_contract` (
  `acq_contract_acq_contract_id` INT NOT NULL,
  `pt_hours_per_week` DECIMAL NOT NULL,
  `hourly_rate` DECIMAL NOT NULL,
  `annual_super_amount` DECIMAL NULL,
  PRIMARY KEY (`acq_contract_acq_contract_id`),
  CONSTRAINT `fk_acq_pt_contract_acq_contract1`
    FOREIGN KEY (`acq_contract_acq_contract_id`)
    REFERENCES `acq_contract` (`acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_payslip_pt_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_payslip_pt_item` (
  `payslip_id` INT NOT NULL,
  `acq_contract_acq_contract_id` INT NOT NULL,
  `number_of_hours` DECIMAL NOT NULL,
  `pay_subtotal` DECIMAL NOT NULL,
  PRIMARY KEY (`payslip_id`, `acq_contract_acq_contract_id`),
  INDEX `fk_acq_payslip_pt_item_acq_pt_contract1_idx` (`acq_contract_acq_contract_id` ASC),
  CONSTRAINT `fk_acq_payslip_pt_item_acq_payslip_indication1`
    FOREIGN KEY (`payslip_id`)
    REFERENCES `acq_payslip_indication` (`payslip_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_acq_payslip_pt_item_acq_pt_contract1`
    FOREIGN KEY (`acq_contract_acq_contract_id`)
    REFERENCES `acq_pt_contract` (`acq_contract_acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_ft_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_ft_contract` (
  `acq_contract_acq_contract_id` INT NOT NULL,
  `salary` DECIMAL NULL,
  `annual_super_amount` DECIMAL NULL,
  PRIMARY KEY (`acq_contract_acq_contract_id`),
  CONSTRAINT `fk_acq_ft_contract_acq_contract1`
    FOREIGN KEY (`acq_contract_acq_contract_id`)
    REFERENCES `acq_contract` (`acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_payslip_ft_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_payslip_ft_item` (
  `payslip_id` INT NOT NULL,
  `acq_contract_acq_contract_id` INT NOT NULL,
  `number_of_hours` DECIMAL NOT NULL,
  `pay_subtotal` DECIMAL NOT NULL,
  PRIMARY KEY (`payslip_id`, `acq_contract_acq_contract_id`),
  INDEX `fk_acq_payslip_ft_item_acq_ft_contract1_idx` (`acq_contract_acq_contract_id` ASC),
  CONSTRAINT `fk_acq_payslip_ft_item_acq_payslip_indication1`
    FOREIGN KEY (`payslip_id`)
    REFERENCES `acq_payslip_indication` (`payslip_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_acq_payslip_ft_item_acq_ft_contract1`
    FOREIGN KEY (`acq_contract_acq_contract_id`)
    REFERENCES `acq_ft_contract` (`acq_contract_acq_contract_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staff_manages_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `staff_manages_store` (
  `acq_staff_acq_person_id` INT NOT NULL,
  `acq_store_acq_store_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `contact_number` VARCHAR(20) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `next_review_date` DATE NOT NULL,
  PRIMARY KEY (`acq_staff_acq_person_id`, `acq_store_acq_store_id`),
  INDEX `fk_acq_staff_has_acq_store_acq_store1_idx` (`acq_store_acq_store_id` ASC),
  INDEX `fk_acq_staff_has_acq_store_acq_staff1_idx` (`acq_staff_acq_person_id` ASC),
  CONSTRAINT `fk_acq_staff_has_acq_store_acq_staff1`
    FOREIGN KEY (`acq_staff_acq_person_id`)
    REFERENCES `acq_staff` (`acq_person_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_acq_staff_has_acq_store_acq_store1`
    FOREIGN KEY (`acq_store_acq_store_id`)
    REFERENCES `acq_store` (`acq_store_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_training_course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_training_course` (
  `training_course_id` INT NOT NULL,
  `course_name` VARCHAR(100) NOT NULL,
  `short_description` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`training_course_id`),
  UNIQUE INDEX `course_name_UNIQUE` (`course_name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_training_course_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_training_course_session` (
  `training_course_session_id` INT NOT NULL,
  `training_course_id` INT NOT NULL,
  `date_session_is_run` DATE NOT NULL,
  `max_number_of_attendees` INT NOT NULL,
  PRIMARY KEY (`training_course_session_id`),
  INDEX `fk_acq_training_course_session_acq_training_course1_idx` (`training_course_id` ASC),
  CONSTRAINT `fk_acq_training_course_session_acq_training_course1`
    FOREIGN KEY (`training_course_id`)
    REFERENCES `acq_training_course` (`training_course_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acq_training_enrolment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acq_training_enrolment` (
  `training_enrolment_id` INT NOT NULL,
  `training_course_session_id` INT NOT NULL,
  `acq_staff_acq_person_id` INT NOT NULL,
  `training_completed` TINYINT NOT NULL,
  `comment` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`training_enrolment_id`),
  INDEX `fk_training_enrolment_acq_training_course_session1_idx` (`training_course_session_id` ASC),
  INDEX `fk_training_enrolment_acq_staff1_idx` (`acq_staff_acq_person_id` ASC),
  CONSTRAINT `fk_training_enrolment_acq_training_course_session1`
    FOREIGN KEY (`training_course_session_id`)
    REFERENCES `acq_training_course_session` (`training_course_session_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_training_enrolment_acq_staff1`
    FOREIGN KEY (`acq_staff_acq_person_id`)
    REFERENCES `acq_staff` (`acq_person_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- this is an addition that is needed to link a full time contract or a part time contract to be allocated to a store.
-- it is safe to assume that a full time contract would only be for 1 store and a part time contract would only be for 1 store.

-- while the staff member may work at other stores it is ok to assume that the part time or full time contract covers hours for 1 store only.
-- note: casual stores depend on the timesheets. Casual staff members can work at multiple stores...

ALTER TABLE acq_pt_contract
add column for_store_id_as_home_store INT not null after acq_contract_acq_contract_id,
add foreign key addition1(for_store_id_as_home_store) references acq_store(acq_store_id) on delete restrict; -- this links part time contract to 1 store

ALTER TABLE acq_ft_contract
add column for_store_id_as_home_store INT not null after acq_contract_acq_contract_id,
add foreign key addition2(for_store_id_as_home_store) references acq_store(acq_store_id) on delete restrict; -- this links full time contract to 1 store


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;