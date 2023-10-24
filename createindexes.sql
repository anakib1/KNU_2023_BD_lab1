USE datasquid;

CREATE INDEX `transactionsByUserId` ON transaction(userId);

CREATE INDEX `pricingPlansByOrgIdAndSourceId` ON pricingplans(organisationId, dataSourceId);