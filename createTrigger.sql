DROP TRIGGER IF EXISTS `PricingPlanChangeTrigger`;

DELIMITER //
CREATE TRIGGER `PricingPlanChangeTrigger`
AFTER UPDATE ON `pricingplans`
FOR EACH ROW
BEGIN
    -- Create a notification for all users of the new organization
    INSERT INTO `notifications` (`notificationId`, `description`, `severity`, `userId`, `notificationTime`)
    SELECT UNHEX(REPLACE(UUID(), '-', '')),
           CONCAT('The pricing plan for your organization has changed. Please review the updates.'),
           2,
           `users`.`userId`,
           NOW()
    FROM `users`
    WHERE organisationId = NEW.organisationId;

END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS `AdminUpdateTrigger`;

DELIMITER //
CREATE TRIGGER AdminUpdateTrigger AFTER UPDATE ON `administrators`
FOR EACH ROW
BEGIN
    INSERT INTO `administratoractionshistory` (entryId, actionTime, actionType, actionContent, administratorId)
    VALUES (UNHEX(REPLACE(UUID(), '-', '')), NOW(), 3, 'Adminstrator entity changed from ...', OLD.administratorId);
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS `DumpRequestUpdateTrigger`;

DELIMITER //
CREATE TRIGGER DumpRequestUpdateTrigger BEFORE UPDATE ON DumpRequests
FOR EACH ROW
BEGIN
    INSERT INTO DumpRequestsHistory (entryId, content, updateTime, requestId)
    VALUES (UNHEX(REPLACE(UUID(), '-', '')), OLD.description, NOW(), OLD.requestId);
END;
//
DELIMITER ;


