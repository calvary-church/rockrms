-- IMPORTANT --
-- USE THE BELOW SQL TO TAKE A PREVIOUSLY RESTORED SQL DATABASE AND MAKE IT USABLE FOR SANDBOX, DEV, OR TEST USAGE --
-- IMPORTANT --

-- CREATE FUNCTION FOR REMOVING NON-ALPHA CHARACTERS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnUtility_RemoveNonAlphaCharacters]') AND type = 'FN')
DROP FUNCTION [dbo].[ufnUtility_RemoveNonAlphaCharacters]
GO

CREATE FUNCTION [dbo].[ufnUtility_RemoveNonAlphaCharacters](@Temp VarChar(1000))
RETURNS VARCHAR(1000)

AS

BEGIN

    DECLARE @KeepValues as VARCHAR(50)
    SET @KeepValues = '%[^a-z]%'
    WHILE PatIndex(@KeepValues, @Temp) > 0
        SET @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    RETURN @Temp
END
GO

-- Create 'RockDBA' so it points to the current server's Logins; we use RockDBA on the Sandbox server at Calvary --
CREATE USER [RockDBA] FOR LOGIN [RockDBA]
GO
ALTER ROLE [db_owner] ADD MEMBER [RockDBA]
GO

-- ADD 'TEST' BANNER --
UPDATE B SET 
	  [PreHtml] = '<h4 style="position:absolute;left:80px;top:6px; color: black;">You are connected to the <strong>Test</strong> database updated 1-2-2018</h4><script>$(".navbar-static-top").css("background-color","hotpink");</script>'
	, [ModifiedDateTime] = GETDATE()
FROM [Block] B
INNER JOIN [BlockType] T ON T.[Id] = B.[BlockTypeId]
WHERE T.[Path] = '~/Blocks/Core/SmartSearch.ascx'
AND B.[Zone] = 'Header'

-- TURN OFF SSL FOR ALL PAGES --
UPDATE [Page] SET [RequiresEncryption] = 0

-- TURN OFF SSL FOR ALL SITES --
UPDATE [Site] SET [RequiresEncryption] = 0

-- INACTIVATE JOBS --
UPDATE [ServiceJob] SET [IsActive] = 0

-- BLANK OUT AND CHANGE TO @SAFETY.NETZ ADDRESSES ALL NON-SYSTEM, NON-CALVARY, NOT BLANK, NOT NULL EMAIL ADDRESSES --
BEGIN
UPDATE [Person]
set [Email] = LOWER(dbo.[ufnUtility_RemoveNonAlphaCharacters]([NickName])) + LOWER(dbo.[ufnUtility_RemoveNonAlphaCharacters]([LastName])) + '@safety.netz'
WHERE [Email] IS NOT NULL AND [Email] NOT LIKE '%@calvaryonline.cc' and [Email] != '' AND IsSystem != 1
END

-- DEACTIVATE ALL MAIL TRANSPORTS --
BEGIN
UPDATE [AttributeValue] SET [Value] = 'False' 
WHERE AttributeId IN 
    (SELECT a.id 
    FROM [EntityType] et 
    INNER JOIN [Attribute] a 
    ON a.EntityTypeId = et.Id AND a.[Key] = 'Active' 
    WHERE et.name LIKE '%Communication.Transport%')
END

-- UPDATE THE MAIL MEDIUM/TRANSPORT SETTINGS TO USE SMTP WITH LOCALHOST/25 --
DECLARE @SMTPEntityTypeId int = ( SELECT TOP 1 [Id] FROM [EntityType] WHERE [Name] = 'Rock.Communication.Transport.SMTP' )
DECLARE @MailEntityTypeId int = ( SELECT TOP 1 [Id] FROM [EntityType] WHERE [Name] = 'Rock.Communication.Medium.Email' )
DECLARE @MailAttributeId int

-- SMTP SERVER --
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @SMTPEntityTypeId AND [Key] = 'Server' )
UPDATE [AttributeValue] SET [Value] = 'localhost' WHERE [AttributeId] = @MailAttributeId

-- SMTP Port --
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @SMTPEntityTypeId AND [Key] = 'Port' )
UPDATE [AttributeValue] SET [Value] = '25' WHERE [AttributeId] = @MailAttributeId

-- SMTP USERNAME --
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @SMTPEntityTypeId AND [Key] = 'UserName' )
UPDATE [AttributeValue] SET [Value] = '' WHERE [AttributeId] = @MailAttributeId

-- SMTP PASSWORD --
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @SMTPEntityTypeId AND [Key] = 'Password' )
UPDATE [AttributeValue] SET [Value] = '' WHERE [AttributeId] = @MailAttributeId

-- SMTP USESSL --
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @SMTPEntityTypeId AND [Key] = 'UseSSL' )
UPDATE [AttributeValue] SET [Value] = 'False' WHERE [AttributeId] = @MailAttributeId

-- MAIL TRANSPORT --
DECLARE @SMTPEntityTypeGuid varchar(50) = ( SELECT LOWER(CAST([Guid] as varchar(50))) FROM [EntityType] WHERE [Id] = @SMTPEntityTypeId )
SET @MailAttributeId = ( SELECT TOP 1 [Id] FROM [Attribute] WHERE [EntityTypeId] = @MailEntityTypeId AND [Key] = 'TransportContainer' )
UPDATE [AttributeValue] SET [Value] = @SMTPEntityTypeGuid WHERE [AttributeId] = @MailAttributeId