-- TRUNCATE  `acq_training_enrolment`;
-- TRUNCATE  `acq_training_course_session`;
-- TRUNCATE  `acq_training_course`;
-- TRUNCATE  `staff_manages_store`;
-- TRUNCATE  `acq_payslip_ft_item`;
-- TRUNCATE  `acq_ft_contract`;
-- TRUNCATE  `acq_payslip_pt_item`;
-- TRUNCATE  `acq_pt_contract`;
-- TRUNCATE  `acq_payslip_timesheet_item`;
-- TRUNCATE  `acq_payslip_indication`;
-- TRUNCATE  `acq_timesheet`;
-- TRUNCATE  `casual_for_stores`;
-- TRUNCATE  `acq_casual_contract`;
-- TRUNCATE  `acq_contract`;
-- TRUNCATE  `acq_staff`;
-- TRUNCATE  `acq_store`;
-- TRUNCATE  `acq_location`;
-- TRUNCATE  `acq_shopping_centre`;
-- TRUNCATE  `acq_foodchain_company`;

-- this is part 1 of the data for you to import
-- it contains everything about stores and locations. Staff, and training.
-- it does not contain any details about contracts or timesheets. This will come in part 2.


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `acq_foodchain_company`
--

LOCK TABLES `acq_foodchain_company` WRITE;
/*!40000 ALTER TABLE `acq_foodchain_company` DISABLE KEYS */;
INSERT INTO `acq_foodchain_company` VALUES (1,'Kay Eff Sea',14000000,'2010-02-20'),(2,'Spring Juice',2000000,'2010-04-30'),(3,'Royal Burgers',5000000,'2011-04-30'),(4,'Burnt',30000000,'2012-06-01'),(5,'Cafe Dux',6000000,'2015-06-01'),(6,'Ronalds',23000000,'2015-06-01'),(7,'Burger Branch',3000000,'2015-06-01'),(8,'Lift',130000000,'2016-06-01'),(9,'Bubble Tea Palace',20000000,'2016-07-01');
/*!40000 ALTER TABLE `acq_foodchain_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_location`
--

LOCK TABLES `acq_location` WRITE;
/*!40000 ALTER TABLE `acq_location` DISABLE KEYS */;
INSERT INTO `acq_location` VALUES (1,200,1,'shop 5, MQ Shopping Centre, 2109',1),(2,210,1,'shop7, Randwick Junction Centre, 2031',2),(3,200,1,'shop 29, Hornsby Shopping Centre, Hornsby 2077',3),(4,215,1,'shop 22. Blacktown Shopping Centre, Blacktown, 2148',4),(5,180,0,'55 High Street, Epping, 2121',NULL),(6,140,0,'12 Bondi Road, Bondi Beach, 2026',NULL),(7,142,0,'88 Atton Road, Marrickville, 2204',NULL),(8,140,0,'3 Worker Place, Macquarie Park, 2113',NULL),(9,140,0,'4 / 1 Central Courtyard, Macquarie University 2109',NULL),(10,140,0,'300 Miller Street, North Sydney, 2060',NULL),(11,140,0,'63 West Street, North Sydney, 2060',NULL),(12,140,0,'121 Pacific Highway, Hornsby, 2077',NULL),(13,350,1,'shop 1, Galleries Victoria, Sydney 2000',5),(14,281,1,'11 Talavera Rd, Macquarie Park 2113',NULL),(15,251,1,'61 Archer St, Chatswood, 2067',NULL),(16,96,1,'6 Mcintosh St, Chatswood 2067',NULL),(17,130,1,'232 Miller St, North Sydney, 2060',NULL),(18,400,1,'183 Botany Road, Waterloo, 2017',NULL),(19,300,1,'600 George Street, Sydney, 2000',NULL),(20,160,1,'6 Mary St, Newtown, 2042',NULL),(21,160,1,'154 Castlereagh St, Sydmey, 2000',NULL),(22,40,0,'330B Victoria Avenue, Chatswood, 2067',NULL),(23,50,1,'shop77, Hornsby Shopping Centre, Hornsby, 2077',3),(24,50,0,'2 / 34 Victoria Road, Marrickville, NSW, 2204',NULL),(25,50,0,'4a/243 Anzac Pde, Kingsford, 2032',NULL),(26,50,0,'123 Longueville Rd, Lane Cove, 2066',NULL);
/*!40000 ALTER TABLE `acq_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_shopping_centre`
--

LOCK TABLES `acq_shopping_centre` WRITE;
/*!40000 ALTER TABLE `acq_shopping_centre` DISABLE KEYS */;
INSERT INTO `acq_shopping_centre` VALUES (1,'MQ Shopping Centre','98501111','98501121'),(2,'Randwick Junction','98501131','98501141'),(3,'Hornsby Shopping Centre','95423785','96751238'),(4,'Blacktown Centre','97682548','97628554'),(5,'Galleries Victoria','92875689','92873661');
/*!40000 ALTER TABLE `acq_shopping_centre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_staff`
--

LOCK TABLES `acq_staff` WRITE;
/*!40000 ALTER TABLE `acq_staff` DISABLE KEYS */;
INSERT INTO `acq_staff` VALUES (1,'Nelson','Tammie','Tammie','Ms','Female',1),(2,'Galloway','Lupe','Lupe','Mr','Male',1),(3,'Wilkinson','Gary','Gary','Mr','Male',1),(4,'Diaz','Gregory','Greg','Mr','Male',0),(5,'Singh','Monte','Monte','Mr','Male',0),(6,'Meyer','Francesco','Chez','Mx','Nonbinary',1),(7,'Hurst','Terence','Terence','Mr','Male',0),(8,'Rose','Silvia','Silvia','Mrs','Female',0),(9,'Woods','Zack','Zack','Mr','Male',1),(10,'Molina','Luisa','Luisa','Ms','Female',0),(11,'Logan','Cedrick','Cedrick','Mr','Male',1),(12,'Rowland','Leo','Leo','Mx','Nonbinary',1),(13,'Guzman','Gilda','Gilda','Ms','Female',1),(14,'Lawrence','Tasha','Tasha','Ms','Female',0),(15,'Garner','Kenny','Kenny','Mr','Male',1),(16,'Richard','Demarcus','Demarcus','Mr','Male',1),(17,'Espinoza','Luigi','Luigi','Mr','Male',1),(18,'Conner','Romeo','Romeo','Mx','Nonbinary',0),(19,'Ferrell','Monty','Monty','Mr','Male',0),(20,'Jennings','Tamara','Tamara','Ms','Female',0),(21,'Andersen','Rhoda','Rhoda','Mx','Nonbinary',1),(22,'Bryan','Kathrine','Kathrine','Mrs','Female',0),(23,'Booker','Drew','Andrea','Ms','Female',0),(24,'Shaffer','Sterling','Sterling','Mr','Male',1),(25,'Mccoy','Young','Young','Mr','Male',0),(26,'Garza','Belinda','Belinda','Ms','Female',1),(27,'Craig','Zachary','Zac','Mr','Male',0),(28,'Vaughan','Milan','Milan','Mr','Male',1),(29,'Schaefer','Diann','Diann','Ms','Female',1),(30,'Brewer','Eduardo','Eddie','Mr','Male',1),(31,'Walls','Vito','Sandy','Mx','Nonbinary',0),(32,'Petersen','Tory','Tory','Mx','Nonbinary',0),(33,'Dyer','Violet','Violet','Mrs','Female',0),(34,'Schneider','Maggie','Maggie','Mrs','Female',0),(35,'Larsen','Lana','Lana','Ms','Female',0),(36,'Wang','Porter','Porter','Mr','Male',0),(37,'Ware','Caroline','Caroline','Ms','Female',1),(38,'Schwartz','Lavern','Lavern','Ms','Female',1),(39,'Bender','Alisha','Alisha','Ms','Female',0),(40,'Costa','Doreen','Dee','Ms','Female',1);
/*!40000 ALTER TABLE `acq_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_store`
--

LOCK TABLES `acq_store` WRITE;
/*!40000 ALTER TABLE `acq_store` DISABLE KEYS */;
INSERT INTO `acq_store` VALUES (1,'k2109a',1,1),(2,'k2031a',1,2),(3,'k2077a',1,3),(4,'k2148a',1,4),(5,'k2121a',1,5),(6,'k2026a',1,6),(7,'k2204a',1,7),(8,'k2113a',1,8),(9,'001',2,9),(10,'002',2,10),(11,'003',2,11),(12,'004',2,12),(13,'Sydney',3,13),(14,'1',4,14),(15,'2',4,15),(16,'1',5,16),(17,'2',5,17),(18,'2017a',6,18),(19,'2017b',6,19),(20,'1',7,20),(21,'2',7,21),(22,'1',8,22),(23,'2',8,23),(24,'1',9,24),(25,'2',9,25),(26,'3',9,26);
/*!40000 ALTER TABLE `acq_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_training_course`
--

LOCK TABLES `acq_training_course` WRITE;
/*!40000 ALTER TABLE `acq_training_course` DISABLE KEYS */;
INSERT INTO `acq_training_course` VALUES (1,'Empathy Training','A course designed for managers and senior staff for how to handle customer interactions and staff interactions'),(2,'Managers Training 1','A course for managers just starting out.'),(3,'Emergency Situations 1','An intriductory course for dealing with emergencies like evacuations, fires, or hostile scenarios'),(4,'Managers Training 2','A course for managers to handle inventory and logistics'),(5,'Escalated Situations 1','Procedures and training for armed roberies or abusive customers');
/*!40000 ALTER TABLE `acq_training_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_training_course_session`
--

LOCK TABLES `acq_training_course_session` WRITE;
/*!40000 ALTER TABLE `acq_training_course_session` DISABLE KEYS */;
INSERT INTO `acq_training_course_session` VALUES (1,1,'2023-02-01',20),(2,1,'2023-03-01',20),(3,1,'2023-04-05',20),(4,1,'2023-05-03',20),(5,1,'2023-06-07',20),(6,1,'2023-10-04',20),(7,2,'2023-02-27',5),(8,2,'2023-05-29',5),(9,2,'2023-08-28',5),(10,3,'2023-01-16',4),(11,3,'2023-01-17',4),(12,3,'2023-01-18',4),(13,3,'2023-01-19',4),(14,3,'2023-01-20',4),(15,3,'2023-01-23',4),(16,3,'2023-01-24',4),(17,3,'2023-01-25',4),(18,4,'2023-03-06',4),(19,4,'2023-06-05',4),(20,4,'2023-09-04',4),(21,4,'2023-10-02',4),(22,5,'2023-01-05',4),(23,5,'2023-01-12',4),(24,5,'2023-01-19',4),(25,5,'2023-01-26',4),(26,5,'2023-02-02',4),(27,5,'2023-02-09',4),(28,5,'2023-02-16',4),(29,5,'2023-02-23',4),(30,5,'2023-03-02',4);
/*!40000 ALTER TABLE `acq_training_course_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `acq_training_enrolment`
--

LOCK TABLES `acq_training_enrolment` WRITE;
/*!40000 ALTER TABLE `acq_training_enrolment` DISABLE KEYS */;
INSERT INTO `acq_training_enrolment` VALUES (1,10,5,0,'none'),(2,10,6,0,'none'),(3,10,8,0,'none'),(4,10,3,0,'none'),(5,11,23,0,'none'),(6,11,7,0,'none'),(7,11,4,0,'none');
/*!40000 ALTER TABLE `acq_training_enrolment` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `casual_for_stores` WRITE;
/*!40000 ALTER TABLE `casual_for_stores` DISABLE KEYS */;
INSERT INTO `casual_for_stores` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(5,4),(6,4),(9,5),(24,17),(25,17),(26,17),(10,18),(11,18),(12,18),(1,20),(14,21),(17,22),(19,23),(20,24),(23,25);
/*!40000 ALTER TABLE `casual_for_stores` ENABLE KEYS */;
UNLOCK TABLES;

-- optional for chaning the data type of payslips to handle decimal numbers rather than rounding to the nearest whole number (for task8). 
-- You dot not have to apply these if you have already finished and worked with the datatypes that you had been working with
ALTER TABLE acq_payslip_indication MODIFY COLUMN net_pay_amount DECIMAL(10,2);  -- was decimal(10,0) in export
ALTER TABLE acq_payslip_indication MODIFY COLUMN gross_pay_amount DECIMAL(10,2);  -- was decimal(10,0) in export
ALTER TABLE acq_payslip_indication MODIFY COLUMN gross_pay_amount DECIMAL(10,2);  -- was decimal(10,0) in export
ALTER TABLE acq_payslip_indication MODIFY COLUMN toal_tax_amount DECIMAL(10,2);  -- was decimal(10,0) in export

ALTER TABLE acq_payslip_ft_item MODIFY COLUMN number_of_hours DECIMAL(6,2); -- was decimal(10,0) in export
ALTER TABLE acq_payslip_ft_item MODIFY COLUMN pay_subtotal DECIMAL(6,2); -- was decimal(10,0) in export

ALTER TABLE acq_payslip_pt_item MODIFY COLUMN number_of_hours DECIMAL(6,2); -- was decimal(10,0) in export
ALTER TABLE acq_payslip_pt_item MODIFY COLUMN pay_subtotal DECIMAL(6,2); -- was decimal(10,0) in export

ALTER TABLE acq_payslip_timesheet_item MODIFY COLUMN number_of_hours DECIMAL(6,2); -- was decimal(10,0) in export
ALTER TABLE acq_payslip_timesheet_item MODIFY COLUMN pay_subtotal DECIMAL(6,2); -- was decimal(10,0) in export


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;