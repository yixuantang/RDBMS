CREATE TABLE `Member` (
  `mid` VARCHAR(5) NOT NULL,
  `mname` VARCHAR(20) NOT NULL,
  `phone` VARCHAR(10) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`mid`));

INSERT INTO `Member` VALUES ('M3412', 'John Smith', '5612312414', '812 Grand St, Brooklyn, NY');
INSERT INTO `Member` VALUES ('M5768', 'Jerry Huang', '8476372654', '400 Jay Street, Brooklyn, NY');
INSERT INTO `Member` VALUES ('M2641', 'Brown Snow', '3485769401', '120 Willoughby Street, Brooklyn, NY');
INSERT INTO `Member` VALUES ('M9742', 'Guru Singh', '3847596823', '300 Bridge Street, Brooklyn, NY');
INSERT INTO `Member` VALUES ('M7549', 'Ivy Yu', '2039485768', '309 Gold Street, Brooklyn, NY');

CREATE TABLE `Book` (
  `bookid` VARCHAR(5) NOT NULL,
  `booktitle` VARCHAR(45) NOT NULL,
  `category` VARCHAR(10) NOT NULL,
  `author` VARCHAR(20) NOT NULL,
  `publishdate` DATETIME NOT NULL,
  PRIMARY KEY (`bookid`));

INSERT INTO `Book` VALUES ('B1245', 'Joan of Arc', 'History', 'Mark Twain', '1896-01-01');
INSERT INTO `Book` VALUES ('B4785', 'Effective Java', 'Program', 'Joshua Bloch', '2018-01-06');
INSERT INTO `Book` VALUES ('B7234', 'DK Guide to Public Speaking', 'Speach', 'Dorling Kindersley', '2013-10-10');
INSERT INTO `Book` VALUES ('B2384', 'Personal Finance: A Interactive Approach', 'Finance', 'French Dan', '2010-01-15');
INSERT INTO `Book` VALUES ('B3984', 'Python For Informatics', 'Program', 'Charles Severance', '2014-04-28');

CREATE TABLE `BookCopy` (
  `copyid` VARCHAR(5) NOT NULL,
  `bookid` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`copyid`),
  FOREIGN KEY (`bookid`) REFERENCES `Book` (`bookid`));

INSERT INTO `BookCopy` VALUES ('BC123', 'B2384');
INSERT INTO `BookCopy` VALUES ('BC423', 'B4785');
INSERT INTO `BookCopy` VALUES ('BC225', 'B4785');
INSERT INTO `BookCopy` VALUES ('BC925', 'B4785');
INSERT INTO `BookCopy` VALUES ('BC142', 'B7234');
INSERT INTO `BookCopy` VALUES ('BC562', 'B2384');
INSERT INTO `BookCopy` VALUES ('BC825', 'B2384');
INSERT INTO `BookCopy` VALUES ('BC396', 'B2384');
INSERT INTO `BookCopy` VALUES ('BC269', 'B3984');
INSERT INTO `BookCopy` VALUES ('BC386', 'B3984');


CREATE TABLE `CheckedOut` (
  `copyid` VARCHAR(5) NOT NULL,
  `mid` VARCHAR(5) NOT NULL,
  `checkoutDate` DATETIME NOT NULL,
  `dueDate` DATETIME NOT NULL,
  `status` ENUM('Holding', 'Returned', 'Overdue') NOT NULL,
  PRIMARY KEY (`copyid`, `mid`, `checkoutDate`),
  FOREIGN KEY (`copyid`) REFERENCES `BookCopy` (`copyid`),
  FOREIGN KEY (`mid`) REFERENCES `Member` (`mid`));

INSERT INTO `CheckedOut` VALUES ('BC123', 'M3412', '2014-01-25', '2014-04-25', 'Returned');
INSERT INTO `CheckedOut` VALUES ('BC123', 'M5768', '2017-03-25', '2017-06-25', 'Holding');
INSERT INTO `CheckedOut` VALUES ('BC225', 'M7549', '2017-02-15', '2017-05-15', 'Holding');
INSERT INTO `CheckedOut` VALUES ('BC925', 'M5768', '2017-01-15', '2017-04-15', 'Returned');
INSERT INTO `CheckedOut` VALUES ('BC423', 'M9742', '2017-01-20', '2017-04-20', 'Overdue');
INSERT INTO `CheckedOut` VALUES ('BC825', 'M2641', '2015-01-20', '2015-04-20', 'Returned');
INSERT INTO `CheckedOut` VALUES ('BC269', 'M7549', '2017-03-20', '2017-06-20', 'Holding');
INSERT INTO `CheckedOut` VALUES ('BC386', 'M2641', '2017-02-20', '2017-05-20', 'Returned');
INSERT INTO `CheckedOut` VALUES ('BC396', 'M9742', '2016-01-20', '2016-04-20', 'Returned');
INSERT INTO `CheckedOut` VALUES ('BC142', 'M5768', '2016-12-20', '2017-02-20', 'Overdue');
