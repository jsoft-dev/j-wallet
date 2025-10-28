# Database Setup Guide for .NET Angular Application

## SQL Server Configuration

This guide will help you set up the SQL Server database for the .NET Angular application.

### Prerequisites

- SQL Server 2019 or later (or SQL Server Express)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Connection to your SQL Server instance

### Connection String Options

The application uses the following connection strings (configured in `appsettings.json`):

#### Option 1: Local SQL Server (Production)
```
Server=localhost;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;
```

#### Option 2: LocalDB (Development)
```
Server=(localdb)\mssqllocaldb;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;
```

#### Option 3: SQL Server with Authentication
```
Server=YOUR_SERVER_NAME;Database=DotNetAngularDb;User Id=sa;Password=YOUR_PASSWORD;TrustServerCertificate=true;Encrypt=false;
```

### Setup Steps

#### Step 1: Verify SQL Server is Running

**On Windows:**
```bash
# Start SQL Server service (if using SQL Server Express)
net start MSSQL$SQLEXPRESS

# Or check if service is running
sc query MSSQL$SQLEXPRESS
```

#### Step 2: Create the Database Automatically

The application will automatically create the database and apply migrations when you first run it. The `Program.cs` file includes:

```csharp
// Apply pending migrations and create database if it doesn't exist
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    dbContext.Database.Migrate();
}
```

#### Step 3: Run the Backend

Simply run the backend, and it will create the database:

```bash
cd Backend
dotnet run
```

You should see output indicating the database was created successfully.

#### Step 4: Verify Database Creation (Optional)

Open SQL Server Management Studio and verify:

1. **Database exists**: `DotNetAngularDb`
2. **Table exists**: `Users`
3. **Columns in Users table**:
   - `Id` (int, Primary Key, Identity)
   - `Username` (nvarchar(100), Unique, Not Null)
   - `Email` (nvarchar(255), Unique, Not Null)
   - `PasswordHash` (nvarchar(max), Not Null)
   - `CreatedAt` (datetime2, Default: GETUTCDATE())
   - `LastLogin` (datetime2, Nullable)
   - `IsActive` (bit, Default: 1)

### Manual Database Setup (Alternative)

If you prefer to create the database manually:

1. Open SQL Server Management Studio
2. Connect to your SQL Server instance
3. Open `Backend\Database\Setup.sql`
4. Execute the script

This will create the database and tables.

### Database Schema

#### Users Table
```sql
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    LastLogin DATETIME2 NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
```

### Creating Test Users

You can add test users directly to the database:

```sql
USE DotNetAngularDb;

-- Insert test user
INSERT INTO Users (Username, Email, PasswordHash, IsActive)
VALUES ('testuser', 'test@example.com', 'HASHED_PASSWORD_HERE', 1);
```

**Note**: Passwords are stored as SHA256 hashes. When registering through the application, passwords are automatically hashed.

### Connection String Configuration

Update `appsettings.json` based on your environment:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;"
  }
}
```

Update `appsettings.Development.json` for development:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;"
  }
}
```

### Common Issues & Solutions

#### Issue: "Cannot connect to SQL Server"

**Solution:**
1. Verify SQL Server service is running
2. Check the server name is correct
3. Ensure firewall allows SQL Server connections
4. Test connection in SSMS first

#### Issue: "Database already exists"

**Solution:**
This is normal. The application will use the existing database. If you want to reset:
1. Open SSMS
2. Right-click the database `DotNetAngularDb`
3. Select "Delete"
4. Run the application again to recreate

#### Issue: "Login failed for user"

**Solution:**
1. Verify you're using Trusted Authentication or correct credentials
2. Check SQL Server Authentication is enabled (if using username/password)
3. Ensure the user has create database permissions

#### Issue: "Cannot open database 'DotNetAngularDb' requested by the login"

**Solution:**
1. Check connection string in `appsettings.json`
2. Verify database name spelling
3. Run the application to auto-create the database

### Entity Framework Core Migrations

The application uses Entity Framework Core for database management. Migrations are stored in the `Migrations` folder.

#### View existing migrations:
```bash
cd Backend
dotnet ef migrations list
```

#### Create a new migration (if you modify models):
```bash
dotnet ef migrations add MigrationName
```

#### Apply migrations:
```bash
dotnet ef database update
```

#### Remove last migration:
```bash
dotnet ef migrations remove
```

### Database Backup

To backup your database:

```sql
BACKUP DATABASE DotNetAngularDb 
TO DISK = 'C:\Backups\DotNetAngularDb.bak'
WITH INIT, COMPRESSION;
```

To restore:

```sql
RESTORE DATABASE DotNetAngularDb 
FROM DISK = 'C:\Backups\DotNetAngularDb.bak'
WITH REPLACE;
```

### Production Considerations

1. **Use Strong Passwords**: Change the JWT secret key in appsettings.json
2. **Enable Encryption**: Set `Encrypt=true` in production connection strings
3. **Use SSL**: Configure SQL Server with SSL certificates
4. **Restrict Access**: Use database role-based security
5. **Enable Auditing**: Track database changes for compliance
6. **Regular Backups**: Schedule automated backups
7. **Monitor Performance**: Use SQL Server Extended Events for monitoring

---

**Last Updated**: 2025

