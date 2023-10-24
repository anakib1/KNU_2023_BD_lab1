CALL GenerateOrganisation('mango');
CALL GenerateOrganisation('pineapple');

INSERT INTO `datasources` (dataSourceId, dataSourceName) VALUE (UNHEX(REPLACE(UUID(), '-', '')), 'Twitter');

CALL AddPricingPlan('mango', 'Twitter');

INSERT INTO `datadumps` (dataDumpId, dataSourceId, fromTime, endTime) VALUE
(UNHEX(REPLACE(UUID(), '-', '')), (SELECT `dataSourceId` FROM datasources LIMIT 1), UTC_TIME(3), NOW());

INSERT INTO transaction (transactionId, userId, amount, postBalance, transactionTime) VALUE
(UNHEX(REPLACE(UUID(), '-', '')), GetUserByName('mango_user_1'), 100, 100, NOW());

CALL BuyDataDump(GetUserByName('mango_user_1'), GetLatestDumpIdByDataSourceName('Twitter'));

INSERT INTO `reviews` (reviewId, userId, dataDumpId, content, rating, creationTime) VALUE
(UNHEX(REPLACE(UUID(), '-', '')), GetUserByName('mango_user_2'), GetLatestDumpIdByDataSourceName('Twitter'),
'Good stuff', 5, NOW());

INSERT INTO `reviews` (reviewId, userId, dataDumpId, content, rating, creationTime) VALUE
(UNHEX(REPLACE(UUID(), '-', '')), GetUserByName('mango_user_3'), GetLatestDumpIdByDataSourceName('Twitter'),
'Average stuff', 3, NOW());

INSERT INTO `dumprequests` (requestId, administratorId, description, stage, creationTime, lastModificationTime) VALUE
(UNHEX(REPLACE(UUID(), '-', '')), (SELECT administratorId from administrators LIMIT 1), 'Initial description', 1, NOW(), NOW());

SELECT GetAverageScoreForDataSource('Twitter');
