﻿namespace GAuth2.Model;
/*
 CREATE TABLE Application(
 AppId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL,
 CreatedByGuid UNIQUEIDENTIFIER NULL,
 CreatedByDisplayName NVARCHAR(255) NULL,
 CreatedOn DATETIME NOT NULL,
 ModifiedByGuid UNIQUEIDENTIFIER NULL,
 ModifiedByDisplayName NVARCHAR(255) NULL,
 ModifiedOn DATETIME NOT NULL,
 ValidStart DATETIME NOT NULL,
 ValidEnd DATETIME NULL,
 Active BIT NOT NULL DEFAULT 1
)
*/

public class Application : GenericRecord
{
    public int AppId { get; set; }
    public string Name { get; set; } = "";
}
