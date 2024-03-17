
-- Insert applications Roster and Notes
INSERT INTO [Application] (ApplicationName, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES ('Roster', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ('Notes', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO

-- Insert the access levels Read, Write, and Admin for all applications (Null AppId)
-- Insert access level Create for application Notes
INSERT INTO [AccessLevel] (AppId, AccessLevelName, Active)
VALUES (NULL, 'Read', 1),
  (NULL, 'Write', 1),
  (NULL, 'Admin', 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Create', 1)
GO

-- Insert two parent resources named "Schema" for Roster application and two named "Process" for Notes application
-- Give the parent resources enumerated values of 1 and 2
INSERT INTO [Resource] (AppId, ResourceKey, ResourceValue, ResourceDisplayName, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Roster'), 'Schema', 1, 'Marketing Teams', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Roster'), 'Schema', 2, 'Development Teams', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Process', 1, 'Project Planning', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Process', 2, 'Requirements Gathering', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO

-- Insert two child resources named "Grouping" for Roster application and two named "Area" for Notes application
-- Give the child resources enumerated values of 1 and 2
INSERT INTO [Resource] (AppId, ResourceKey, ResourceValue, ResourceDisplayName, ParentResourceId, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Roster'), 'Grouping', 1, 'Product Alpha Team', (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Schema' AND ResourceValue = 1), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Roster'), 'Grouping', 2, 'Dashboarding Team', (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Schema' AND ResourceValue = 2), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Area', 1, 'Product Aplha Notes', (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Process' AND ResourceValue = 1), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1),
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Area', 2, 'Salesforce Dashboard', (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Process' AND ResourceValue = 2), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO

-- Insert a child resource for the child resource "Area/Product Alpha Notes" with a "ResourceKey" of "Note" and DisplayName of "Marketing Plan"
INSERT INTO [Resource] (AppId, ResourceKey, ResourceValue, ResourceDisplayName, ParentResourceId, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES
  ((SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'), 'Note', 1, 'Marketing Plan', (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Area' AND ResourceValue = 1), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO


-- Insert three rule types named "Individual", "Group", "Department", and "Domain"
INSERT INTO [RuleType] (RuleTypeName, Active)
VALUES ('Individual', 1),
  ('Group', 1),
  ('Department', 1),
  ('Domain', 1),
  ('All', 1)
GO


-- Insert a rule for the "Marketing Plan" resource with the "Department" rule type and a value of "Marketing"
INSERT INTO [AccessRule] (AppId, ResourceId, AccessLevelId, RuleTypeId, AccessRuleValue, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES (
  (SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'),
  (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Note' AND ResourceValue = 1),
  (SELECT AccessLevelId FROM [AccessLevel] WHERE AccessLevelName = 'Write'),
  (SELECT RuleTypeId FROM [RuleType] WHERE RuleTypeName = 'Department'), 'Marketing', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO

-- Insert a rule for the Roster application with the "All" rule type and a with a AccessLevelId of "Read"
INSERT INTO [AccessRule] (AppId, AccessLevelId, RuleTypeId, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES (
  (SELECT AppId FROM [Application] WHERE ApplicationName = 'Roster'),
  (SELECT AccessLevelId FROM [AccessLevel] WHERE AccessLevelName = 'Read'),
  (SELECT RuleTypeId FROM [RuleType] WHERE RuleTypeName = 'All'), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO

-- Insert a rule for Product Alpha Notes with the "Department" rule type and a value of "Marketing"
INSERT INTO [AccessRule] (AppId, ResourceId, AccessLevelId, RuleTypeId, AccessRuleValue, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES (
  (SELECT AppId FROM [Application] WHERE ApplicationName = 'Notes'),
  (SELECT ResourceId FROM [Resource] WHERE ResourceKey = 'Area' AND ResourceValue = 1),
  (SELECT AccessLevelId FROM [AccessLevel] WHERE AccessLevelName = 'Create'),
  (SELECT RuleTypeId FROM [RuleType] WHERE RuleTypeName = 'Department'), 'Marketing', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)
GO



