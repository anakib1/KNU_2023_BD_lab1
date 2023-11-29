DROP DATABASE datasquid;
CREATE DATABASE datasquid;

USE datasquid;

DROP TABLE IF EXISTS `DataSources`;
CREATE TABLE `DataSources`
(
 `dataSourceId`   binary(16) NOT NULL ,
 `dataSourceName` varchar(45) NOT NULL ,

PRIMARY KEY (`dataSourceId`)
);

DROP TABLE IF EXISTS `Organisations`;
CREATE TABLE `Organisations`
(
 `organisationId`   binary(16) NOT NULL ,
 `organisationName` varchar(45) NOT NULL ,
 `creationTime`     timestamp NOT NULL ,

PRIMARY KEY (`organisationId`)
);

DROP TABLE IF EXISTS `Administrators`;
CREATE TABLE `Administrators`
(
 `administratorId`        binary(16) NOT NULL ,
 `adminName`              varchar(45) NOT NULL ,
 `organisationId`         binary(16) NOT NULL ,
 `canAddUsers`            boolean NOT NULL ,
 `canRemoveUsers`         boolean NOT NULL ,
 `canAddAdmins`           boolean NOT NULL ,
 `canRemoveAdmins`        boolean NOT NULL ,
 `canCreateNotifications` boolean NOT NULL ,
 `canCreateRequests`      boolean NOT NULL ,

PRIMARY KEY (`administratorId`),
KEY `FK_1` (`organisationId`),
CONSTRAINT `FK_4` FOREIGN KEY `FK_1` (`organisationId`) REFERENCES `Organisations` (`organisationId`)
);
-- ************************************** `DumpRequests`

DROP TABLE IF EXISTS `DumpRequests`;
CREATE TABLE `DumpRequests`
(
 `requestId`            binary(16) NOT NULL ,
 `administratorId`      binary(16) NOT NULL ,
 `description`          varchar(2048) NOT NULL ,
 `stage`                integer NOT NULL ,
 `creationTime`         timestamp NOT NULL ,
 `lastModificationTime` timestamp NOT NULL ,

PRIMARY KEY (`requestId`),
KEY `FK_1` (`administratorId`),
CONSTRAINT `FK_16` FOREIGN KEY `FK_1` (`administratorId`) REFERENCES `Administrators` (`administratorId`)
);

DROP TABLE IF EXISTS `DumpRequestsHistory`;
CREATE TABLE `DumpRequestsHistory`
(
 `entryId`    binary(16) NOT NULL ,
 `content`    varchar(2048) NOT NULL ,
 `updateTime` timestamp NOT NULL ,
 `requestId`  binary(16) NOT NULL ,

PRIMARY KEY (`entryId`),
KEY `FK_1` (`requestId`),
CONSTRAINT `FK_17` FOREIGN KEY `FK_1` (`requestId`) REFERENCES `DumpRequests` (`requestId`)
);


-- ************************************** `AdministratorActionsHistory`
DROP TABLE IF EXISTS `AdministratorActionsHistory`;
CREATE TABLE `AdministratorActionsHistory`
(
 `entryId`         binary(16) NOT NULL ,
 `actionTime`      timestamp NOT NULL ,
 `actionType`      integer NOT NULL ,
 `actionContent`   BLOB(1024) NOT NULL ,
 `administratorId` binary(16) NOT NULL ,

PRIMARY KEY (`entryId`),
KEY `FK_1` (`administratorId`),
CONSTRAINT `FK_5` FOREIGN KEY `FK_1` (`administratorId`) REFERENCES `Administrators` (`administratorId`)
);

CREATE TABLE `Users`
(
 `userId`         binary(16) NOT NULL ,
 `userName`       varchar(45) NOT NULL ,
 `organisationId` binary(16) NOT NULL ,
 `creationTime`   timestamp NOT NULL ,

PRIMARY KEY (`userId`),
KEY `FK_1` (`organisationId`),
CONSTRAINT `FK_1` FOREIGN KEY `FK_1` (`organisationId`) REFERENCES `Organisations` (`organisationId`)
);




CREATE TABLE `Transaction`
(
 `transactionId`   binary(16) NOT NULL ,
 `userId`          binary(16) NOT NULL ,
 `amount`          integer NOT NULL ,
 `postBalance`     integer NOT NULL ,
 `transactionTime` timestamp NOT NULL ,

PRIMARY KEY (`transactionId`),
KEY `FK_1` (`userId`),
CONSTRAINT `FK_13` FOREIGN KEY `FK_1` (`userId`) REFERENCES `Users` (`userId`)
);
CREATE TABLE `Notifications`
(
 `notificationId`   binary(16) NOT NULL ,
 `description`      varchar(128) NOT NULL ,
 `severity`         int NOT NULL ,
 `userId`           binary(16) NOT NULL ,
 `notificationTime` timestamp NOT NULL ,

PRIMARY KEY (`notificationId`),
KEY `FK_1` (`userId`),
CONSTRAINT `FK_18` FOREIGN KEY `FK_1` (`userId`) REFERENCES `Users` (`userId`)
);
CREATE TABLE `DataDumps`
(
 `dataDumpId`   binary(16) NOT NULL ,
 `dataSourceId` binary(16) NOT NULL ,
 `fromTime`     timestamp NOT NULL ,
 `endTime`      timestamp NOT NULL ,

PRIMARY KEY (`dataDumpId`),
KEY `FK_1` (`dataSourceId`),
CONSTRAINT `FK_2` FOREIGN KEY `FK_1` (`dataSourceId`) REFERENCES `DataSources` (`dataSourceId`)
);

CREATE TABLE `DataDumpEntries`
(
 `entryId`    binary(16) NOT NULL ,
 `content`    binary(16) NOT NULL ,
 `entryTime`  timestamp NOT NULL ,
 `dataDumpId` binary(16) NOT NULL ,

PRIMARY KEY (`entryId`),
KEY `FK_1` (`dataDumpId`),
CONSTRAINT `FK_3` FOREIGN KEY `FK_1` (`dataDumpId`) REFERENCES `DataDumps` (`dataDumpId`)
);
CREATE TABLE `UserOwnedDumps`
(
 `entryId`        binary(16) NOT NULL ,
 `userId`         binary(16) NOT NULL ,
 `dataDumpId`     binary(16) NULL ,
 `dataSourceId`   binary(16) NULL ,
 `purchaseTime`   timestamp NOT NULL ,
 `expireTime`     timestamp NOT NULL ,
 `isSubscription` boolean NOT NULL ,

PRIMARY KEY (`entryId`),
KEY `FK_1` (`userId`),
CONSTRAINT `FK_10` FOREIGN KEY `FK_1` (`userId`) REFERENCES `Users` (`userId`),
KEY `FK_2` (`dataDumpId`),
CONSTRAINT `FK_10_1` FOREIGN KEY `FK_2` (`dataDumpId`) REFERENCES `DataDumps` (`dataDumpId`),
KEY `FK_3` (`dataSourceId`),
CONSTRAINT `FK_15` FOREIGN KEY `FK_3` (`dataSourceId`) REFERENCES `DataSources` (`dataSourceId`)
);
CREATE TABLE `Reviews`
(
 `reviewId`     binary(16) NOT NULL ,
 `userId`       binary(16) NOT NULL ,
 `dataDumpId`   binary(16) NOT NULL ,
 `content`      varchar(2048) NOT NULL ,
 `rating`       integer NOT NULL ,
 `creationTime` timestamp NOT NULL ,

PRIMARY KEY (`reviewId`),
KEY `FK_1` (`userId`),
CONSTRAINT `FK_19` FOREIGN KEY `FK_1` (`userId`) REFERENCES `Users` (`userId`),
KEY `FK_2` (`dataDumpId`),
CONSTRAINT `FK_20` FOREIGN KEY `FK_2` (`dataDumpId`) REFERENCES `DataDumps` (`dataDumpId`)
);
CREATE TABLE `PricingPlans`
(
 `pricingId`      binary(16) NOT NULL ,
 `userId`         binary(16) NULL ,
 `organisationId` binary(16) NULL ,
 `dataSourceId`   binary(16) NULL ,
 `dataDumpId`     binary(16) NULL ,
 `price`          integer NOT NULL ,

PRIMARY KEY (`pricingId`),
KEY `FK_2` (`userId`),
CONSTRAINT `FK_7` FOREIGN KEY `FK_2` (`userId`) REFERENCES `Users` (`userId`),
KEY `FK_2_1` (`dataSourceId`),
CONSTRAINT `FK_7_1` FOREIGN KEY `FK_2_1` (`dataSourceId`) REFERENCES `DataSources` (`dataSourceId`),
KEY `FK_3` (`organisationId`),
CONSTRAINT `FK_8` FOREIGN KEY `FK_3` (`organisationId`) REFERENCES `Organisations` (`organisationId`),
KEY `FK_4` (`dataDumpId`),
CONSTRAINT `FK_14` FOREIGN KEY `FK_4` (`dataDumpId`) REFERENCES `DataDumps` (`dataDumpId`)
);


CREATE TABLE `SubscriptionPlans`
(
 `subscriptionId`  binary(16) NOT NULL ,
 `organisationId`  binary(16) NOT NULL ,
 `userId`          binary(16) NOT NULL ,
 `period`          integer NOT NULL ,
 `totalPrice`      integer NOT NULL ,
 `pricingStrategy` int NOT NULL ,

PRIMARY KEY (`subscriptionId`),
KEY `FK_1` (`organisationId`),
CONSTRAINT `FK_11` FOREIGN KEY `FK_1` (`organisationId`) REFERENCES `Organisations` (`organisationId`),
KEY `FK_2` (`userId`),
CONSTRAINT `FK_12` FOREIGN KEY `FK_2` (`userId`) REFERENCES `Users` (`userId`)
);

