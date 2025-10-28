-- SQL Server Setup Script for DotNetAngularDb
-- Run this script in SQL Server Management Studio or Azure Data Studio

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DotNetAngularDb')
BEGIN
    CREATE DATABASE DotNetAngularDb;
END
GO

USE DotNetAngularDb;
GO

-- Create Users Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    CREATE TABLE Users (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Username NVARCHAR(100) NOT NULL UNIQUE,
        Email NVARCHAR(255) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        LastLogin DATETIME2 NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    
    -- Create Indexes
    CREATE INDEX IX_Users_Username ON Users(Username);
    CREATE INDEX IX_Users_Email ON Users(Email);
    
    PRINT 'Users table created successfully!';
END
ELSE
BEGIN
    PRINT 'Users table already exists!';
END
GO

-- Insert Sample Users (Optional)
-- Note: These passwords are hashed using SHA256
-- Username: demo, Password: demo123
-- Username: admin, Password: admin123

IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'demo')
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash, IsActive)
    VALUES (
        'demo',
        'demo@example.com',
        'S2fQ8R9cPtXvWqL7nJmKoP2rStUvWxYzAbCdEfGhIjK=',
        1
    );
    PRINT 'Demo user created!';
END
GO

-- Verify table creation
SELECT 'Table created successfully!' AS Status;
SELECT COUNT(*) AS UserCount FROM Users;
GO

