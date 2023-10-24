SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM administratoractionshistory;
DELETE FROM administrators;
DELETE FROM datadumpentries;
DELETE FROM datadumps;
DELETE FROM datasources;
DELETE FROM dumprequests;
DELETE FROM dumprequestshistory;
DELETE FROM notifications;
DELETE FROM organisations;
DELETE FROM pricingplans;
DELETE FROM reviews;
DELETE FROM subscriptionplans;
DELETE FROM transaction;
DELETE FROM userowneddumps;
DELETE FROM users;

SET FOREIGN_KEY_CHECKS = 1;