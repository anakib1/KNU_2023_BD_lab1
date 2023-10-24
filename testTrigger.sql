UPDATE `pricingplans` SET `price` = FLOOR(`price` * (1 + 30/100));
-- increases price for 30 percents. Should produce notifications.

UPDATE `administrators` SET `adminName` = CONCAT(`adminName`, '1');
-- changes admin, should write into admin history

UPDATE `dumprequests` SET `description` = 'Changed description' WHERE `description` <> 'Changed description' LIMIT 1;
-- should add to requests history.