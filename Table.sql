CREATE TABLE `job_challandetails` (
  `Id` bigint(100) NOT NULL AUTO_INCREMENT,
  `ChallanKey` varchar(500) NOT NULL,
  `ChallanNo` varchar(500) NOT NULL,
  `ChallanDate` date NOT NULL,
  `SampleCollectedOn` date DEFAULT NULL,
  `SampleSentBy` varchar(200) DEFAULT NULL,
  `Address` varchar(1000) DEFAULT NULL,
  `SampleType` varchar(100) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `CreatedBy` varchar(100) DEFAULT NULL,
  `CreatedOn` date DEFAULT NULL,
  `ModifiedBy` varchar(100) DEFAULT NULL,
  `ModifiedOn` date DEFAULT NULL,
  `Area` varchar(100) DEFAULT NULL,
  KEY `Pk_Id` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `job_purposedetails` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ChallanNo` varchar(200) NOT NULL,
  `ChallanDetailsId` bigint(20) NOT NULL,
  `SampleId` bigint(200) DEFAULT NULL,
  `SampleNo` varchar(200) DEFAULT NULL,
  `Purpose` varchar(100) NOT NULL,
  `PurposeParameter` varchar(100) NOT NULL,
  `NumberOfSample` int(11) DEFAULT NULL,
  `SampleType` varchar(100) DEFAULT NULL,
  `Amount` decimal(10,0) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `CreatedBy` varchar(100) DEFAULT NULL,
  `CreatedOn` date DEFAULT NULL,
  `ModifiedBy` varchar(100) DEFAULT NULL,
  `ModifiedOn` date DEFAULT NULL,
  `Report` varchar(2000) DEFAULT NULL,
  `Observation` varchar(200) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `TestCommandedOn` date DEFAULT NULL,
  KEY `PK_Id` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `job_sampledeatils` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ChallanNo` varchar(200) DEFAULT NULL,
  `Purpose` varchar(100) DEFAULT NULL,
  `SampleId` bigint(20) DEFAULT NULL,
  `SampleName` varchar(100) DEFAULT NULL,
  `Report` varchar(2000) DEFAULT NULL,
  `Status` varchar(100) DEFAULT NULL,
  `Observation` varchar(100) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  KEY `PK_Id` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `jobdetails` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ChallanNo` varchar(200) NOT NULL,
  `ChallanDate` date NOT NULL,
  `DateOfCollection` date DEFAULT NULL,
  `DateOfReceipt` date DEFAULT NULL,
  `SourceAsPerLabel` varchar(1000) DEFAULT NULL,
  `SampleSentBy` varchar(200) DEFAULT NULL,
  `CreatedBy` varchar(100) DEFAULT NULL,
  `CreatedOn` date DEFAULT NULL,
  `ModifiedBy` varchar(100) DEFAULT NULL,
  `ModifiedOn` date DEFAULT NULL,
  `JobTitle` varchar(50) DEFAULT NULL,
  `Amount` decimal(10,0) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `UserPurpose` varchar(100) DEFAULT NULL,
  `Result` varchar(2000) DEFAULT NULL,
  `Report` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `jobresult` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Parameter` varchar(500) DEFAULT NULL,
  `Result` varchar(100) DEFAULT NULL,
  `AcceptableLimit` varchar(100) DEFAULT NULL,
  `PermissableLimit` varchar(100) DEFAULT NULL,
  `ParameterId` bigint(20) DEFAULT NULL,
  `SampleNumber` varchar(200) DEFAULT NULL,
  `ChallanNo` varchar(200) DEFAULT NULL,
  `JobTitle` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `parameters` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `AcceptableLimit` varchar(100) DEFAULT NULL,
  `PermissableLimit` varchar(100) DEFAULT NULL,
  `CreatedBy` varchar(200) DEFAULT NULL,
  `CreatedOn` date DEFAULT NULL,
  `ModifiedBy` varchar(200) DEFAULT NULL,
  `ModifiedOn` date DEFAULT NULL,
  `HasDrinkingPurpose` bit(1) DEFAULT NULL,
  `HasConstructionPurpose` bit(1) DEFAULT NULL,
  `HasAnalyticalPurpose` bit(1) DEFAULT NULL,
  `ParameterType` varchar(100) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

