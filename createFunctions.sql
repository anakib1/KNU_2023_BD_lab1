DROP PROCEDURE IF EXISTS  `GenerateOrganisation`;

DELIMITER //
CREATE PROCEDURE GenerateOrganisation(orgName CHAR(36))
BEGIN
    DECLARE mangoUUID BINARY(16);
    SET mangoUUID = UNHEX(REPLACE(UUID(), '-', ''));
    INSERT INTO `organisations` (organisationId, organisationName, creationTime) value (mangoUUID, orgName, NOW());
    INSERT INTO `users` (userId, userName, organisationId, creationTime) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_user_1'), mangoUUID, NOW());
    INSERT INTO `users` (userId, userName, organisationId, creationTime) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_user_2'), mangoUUID, NOW());
    INSERT INTO `users` (userId, userName, organisationId, creationTime) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_user_3'), mangoUUID, NOW());
    INSERT INTO `users` (userId, userName, organisationId, creationTime) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_user_4'), mangoUUID, NOW());
    INSERT INTO `users` (userId, userName, organisationId, creationTime) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_user_5'), mangoUUID, NOW());
    INSERT INTO `administrators` (administratorId, adminName, organisationId, canAddUsers, canRemoveUsers, canAddAdmins, canRemoveAdmins, canCreateNotifications, canCreateRequests) value (UNHEX(REPLACE(UUID(), '-', '')), CONCAT(orgName, '_admin'), mangoUUID, true, true, true, true, true, true);

END;
//
DELIMITER ;


DROP PROCEDURE IF EXISTS  `AddPricingPlan`;

DELIMITER //
CREATE PROCEDURE AddPricingPlan(orgName CHAR(36), dataSourceName CHAR(36))
BEGIN
    DECLARE orgId BINARY(16);
    DECLARE dsId BINARY(16);


    SELECT `organisationId` INTO orgId
    FROM `organisations`
    WHERE `organisations`.`organisationName` = orgName LIMIT 1;


    SELECT `dataSourceId` INTO dsId
    FROM `datasources`
    WHERE `datasources`.`dataSourceName` = dataSourceName LIMIT 1;

    INSERT INTO `pricingplans` (pricingId, userId, organisationId, dataSourceId, dataDumpId, price)
    VALUE  (UNHEX(REPLACE(UUID(), '-', '')), NULL, orgId, dsId, NULL, 10);

END;
//
DELIMITER ;

DROP FUNCTION IF EXISTS `GetUserByName`;
DELIMITER //
CREATE FUNCTION GetUserByName(userName CHAR(45)) RETURNS BINARY(16)
BEGIN
    RETURN (SELECT userId FROM users WHERE users.userName = userName LIMIT 1);
END;
//
DELIMITER ;

DROP FUNCTION IF EXISTS `GetLatestDumpIdByDataSourceName`;
DELIMITER //
CREATE FUNCTION GetLatestDumpIdByDataSourceName(sourceName CHAR(45)) RETURNS BINARY(16)
BEGIN
    DECLARE sourceId BINARY(16);
    SELECT dataSourceId from `datasources` WHERE `datasources`.`dataSourceName` = sourceName LIMIT 1 INTO sourceId;
    RETURN (SELECT `dataDumpId` FROM datadumps WHERE datadumps.dataSourceId = sourceId ORDER BY `endTime` DESC LIMIT 1);
END;
//
DELIMITER ;

DROP FUNCTION IF EXISTS `GetUserBalance`;
DELIMITER  //
CREATE FUNCTION GetUserBalance(userId BINARY(16)) RETURNS INT
BEGIN
    RETURN (SELECT `postBalance` FROM `transaction` WHERE `transaction`.`userId` = userId ORDER BY `transactionTime` DESC LIMIT 1);
END;
//
DELIMITER ;


DROP PROCEDURE IF EXISTS `BuyDataDump`;

DELIMITER //
CREATE PROCEDURE BuyDataDump(userId BINARY(16), dataDumpId binary(16))
BEGIN
    DECLARE balance INT;
    DECLARE price INT;
    DECLARE planId BINARY(16);

    DECLARE dsId BINARY(16);
    DECLARE orgId BINARY(16);

    SELECT `dataSourceId` from `datadumps` where `datadumps`.`dataDumpId` = dataDumpId LIMIT 1 INTO dsId;
    SELECT `organisationId` from `users` where `users`.`userId` = userId LIMIT 1 INTO orgId;

    SELECT `pricingId` from `pricingplans`
    WHERE
        (`pricingplans`.`dataDumpId` = `dataDumpId`
        OR `pricingplans`.dataSourceId = `dsId`)
      AND
        (`pricingplans`.userId = userId
        OR `pricingplans`.organisationId = orgId)
    LIMIT 1
    INTO `planId`;


    SET balance = GetUserBalance(userId);
    SELECT pricingplans.`price` from pricingplans where pricingId = planId into price;

    IF balance >= price THEN
        INSERT INTO `userowneddumps` (entryId, userId, dataDumpId, dataSourceId, purchaseTime, expireTime, isSubscription)
        VALUE (UNHEX(REPLACE(UUID(), '-', '')), userId, dataDumpId, NULL, NOW(), TIMESTAMP('2024-01-01 00:00:00'), false);

        INSERT INTO `transaction` (transactionId, userId, amount, postBalance, transactionTime)
        VALUE (UNHEX(REPLACE(UUID(), '-', '')), userId, -price, balance - price, NOW());
    ELSE
        BEGIN

        END;
    END IF;

END;
//
DELIMITER ;


DROP FUNCTION IF EXISTS `GetAverageScoreForDataSource`;
DELIMITER  //
CREATE FUNCTION GetAverageScoreForDataSource(sourceName VARCHAR(45)) RETURNS FLOAT
BEGIN
    DECLARE dsId binary(16);
    SELECT (`dataSourceId`) INTO dsId FROM `datasources` WHERE `datasources`.dataSourceName = sourceName LIMIT 1;
    RETURN (SELECT AVG(`rating`) FROM `reviews` WHERE `reviews`.`dataDumpId` IN (SELECT `datadumps`.`dataDumpId` FROM `datadumps` WHERE `datadumps`.`dataSourceId` = dsId));
END;
//
DELIMITER ;