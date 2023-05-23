SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `as3` ;
CREATE SCHEMA IF NOT EXISTS `as3` DEFAULT CHARACTER SET utf8 ;
USE `as3` ;

-- -----------------------------------------------------
-- Create below: Table `as3`.`regions`
-- -----------------------------------------------------

CREATE TABLE `regions` (
  `REGION_ID` decimal(5,0) NOT NULL,
  `REGION_NAME` varchar(25) NOT NULL,
  PRIMARY KEY (`REGION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Create below: Table `as3`.`countries`
-- -----------------------------------------------------

CREATE TABLE `countries` (
  `COUNTRY_ID` char(2) NOT NULL,
  `COUNTRY_NAME` varchar(45) NOT NULL,
  `REGION_ID` decimal(5,0) NOT NULL,
  PRIMARY KEY (`COUNTRY_ID`),
  KEY `REGION_ID_idx` (`REGION_ID`),
  CONSTRAINT `REGION_ID` FOREIGN KEY (`REGION_ID`) REFERENCES `regions` (`REGION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Create below: Table `as3`.`locations`
-- -----------------------------------------------------

CREATE TABLE `locations` (
  `LOCATION_ID` decimal(4,0) NOT NULL,
  `STREET_ADDRESS` varchar(40) DEFAULT NULL,
  `POSTAL_CODE` varchar(12) DEFAULT NULL,
  `CITY` varchar(30) NOT NULL,
  `STATE_PROVINCE` varchar(25) DEFAULT NULL,
  `COUNTRY_ID` char(2) NOT NULL,
  PRIMARY KEY (`LOCATION_ID`),
  KEY `COUNTRY_ID_idx` (`COUNTRY_ID`),
  CONSTRAINT `COUNTRY_ID` FOREIGN KEY (`COUNTRY_ID`) REFERENCES `countries` (`COUNTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Create below: Table `as3`.`jobs`
-- -----------------------------------------------------

CREATE TABLE `jobs` (
  `JOB_ID` varchar(10) NOT NULL,
  `JOB_TITLE` varchar(35) NOT NULL,
  `MIN_SALARY` decimal(6,0) DEFAULT NULL,
  `MAX_SALARY` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`JOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Create below: Table `as3`.`employees`
-- -----------------------------------------------------

CREATE TABLE `employees` (
  `EMPLOYEE_ID` decimal(6,0) NOT NULL,
  `FIRST_NAME` varchar(20) DEFAULT NULL,
  `LAST_NAME` varchar(25) NOT NULL,
  `EMAIL` varchar(45) NOT NULL,
  `PHONE_NUMBER` varchar(20) DEFAULT NULL,
  `HIRE_DATE` date DEFAULT NULL,
  `JOB_ID` varchar(10) NOT NULL,
  `SALARY` decimal(8,2) DEFAULT NULL,
  `COMMISSION_PCT` decimal(3,2) DEFAULT '0.00',
  `MANAGER_ID` decimal(6,0) NOT NULL,
  `DEPARTMENT_ID` int NOT NULL,
  PRIMARY KEY (`EMPLOYEE_ID`),
  KEY `DEPARTMENT_ID__idx` (`DEPARTMENT_ID`),
  CONSTRAINT `DEPARTMENT_ID_` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `departments` (`DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Create below: Table `as3`.`departments`
-- -----------------------------------------------------

CREATE TABLE `departments` (
  `DEPARTMENT_ID` int NOT NULL,
  `DEPARTMENT_NAME` varchar(45) NOT NULL,
  `MANAGER_ID` decimal(6,0) DEFAULT NULL,
  `LOCATION_ID` decimal(4,0) NOT NULL,
  PRIMARY KEY (`DEPARTMENT_ID`),
  KEY `LOCATION_ID_idx` (`LOCATION_ID`),
  CONSTRAINT `LOCATION_ID` FOREIGN KEY (`LOCATION_ID`) REFERENCES `locations` (`LOCATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Create below: Table `as3`.`job_history`
-- -----------------------------------------------------

CREATE TABLE `job_history` (
  `EMPLOYEE_ID` decimal(6,0) NOT NULL,
  `START_DATE` date NOT NULL,
  `END_DATE` date NOT NULL,
  `JOB_ID` varchar(10) DEFAULT NULL,
  `DEPARTMENT_ID` int DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEE_ID`,`START_DATE`),
  KEY `JOB_ID_idx` (`JOB_ID`),
  KEY `DEPARTMENT_ID_idx` (`DEPARTMENT_ID`),
  CONSTRAINT `DEPARTMENT_ID` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `departments` (`DEPARTMENT_ID`),
  CONSTRAINT `EMPLOYEE_ID` FOREIGN KEY (`EMPLOYEE_ID`) REFERENCES `employees` (`EMPLOYEE_ID`),
  CONSTRAINT `JOB_ID` FOREIGN KEY (`JOB_ID`) REFERENCES `jobs` (`JOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- End of coding
-- -----------------------------------------------------

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
