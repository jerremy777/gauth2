-- Create a test "Dashboard" database with a schema named "[Gum]" and a table named [AppUser]
USE [Dashboard]

CREATE SCHEMA [Gum]
GO

CREATE TABLE [Gum].[AppUser](
  [Guid] [uniqueidentifier] NOT NULL,
  [FullName] [nvarchar](255) NULL,
  [FirstName] [nvarchar](255) NULL,
  [LastName] [nvarchar](255) NULL,
  [Title] [nvarchar](255) NULL,
  [Description] [nvarchar](255) NULL,
  [DisplayName] [nvarchar](255) NULL,
  [Department] [nvarchar](255) NULL,
  [Uid] [nvarchar](255) NULL,
  [Active] [bit] NOT NULL,
  [Domain] [char](2) NULL
)
GO

-- Insert some test data into AppUser table with the name "Pizza Wizza", "Craig Thomas", "Olify Wolify", and "Jiffy Diffy" and two
-- departments "Marketing" and "IT" and the titles "Manager", "Developer", and "Senior Manager" and two domains "NA" and "EU"
INSERT INTO [Gum].[AppUser] ([Guid], [FullName], [FirstName], [LastName], [Title], [Description], [DisplayName], [Department], [Uid], [Active], [Domain])
VALUES
  (NEWID(), 'Pizza Wizza', 'Pizza', 'Wizza', 'Manager', 'Marketing Manager', 'Pizza Wizza', 'Marketing', 'pwizza', 1, 'NA'),
  (NEWID(), 'Craig Thomas', 'Craig', 'Thomas', 'Developer', 'Software Developer', 'Craig Thomas', 'IT', 'cthomas', 1, 'EU'),
  (NEWID(), 'Olify Wolify', 'Olify', 'Wolify', 'Senior Manager', 'Senior Marketing Manager', 'Olify Wolify', 'Marketing', 'owolify', 1, 'NA'),
  (NEWID(), 'Jiffy Diffy', 'Jiffy', 'Diffy', 'Developer', 'Software Developer', 'Jiffy Diffy', 'IT', 'jdiffy', 1, 'NA')
GO

