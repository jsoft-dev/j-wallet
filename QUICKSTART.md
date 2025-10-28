# Quick Start Guide

## Complete Setup for .NET Angular Login Application with SQL Server

### Prerequisites Checklist
- ✅ .NET SDK 9.0 installed (`dotnet --version`)
- ✅ SQL Server 2019+ running (or SQL Server Express)
- ✅ Node.js 18+ installed (`node --version`)
- ✅ npm installed (`npm --version`)

---

## 5-Minute Setup

### 1. Verify SQL Server Connection (30 seconds)

Update the connection string in `Backend/appsettings.json` if needed:

**For Local SQL Server:**
```json
"DefaultConnection": "Server=localhost;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;"
```

**For LocalDB (Development):**
```json
"DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;"
```

### 2. Start Backend (2 minutes)

```bash
cd Backend
dotnet run
```

**Expected Output:**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
      Now listening on: http://localhost:5000
```

The database will be created automatically with the Users table.

### 3. Start Frontend (2 minutes)

**In a new terminal:**

```bash
cd Frontend
ng serve
```

**Expected Output:**
```
Application bundle generation complete.
✔ Application bundle generated successfully.
Watch mode enabled. Application will be automatically recompiled upon file change.
✔ build succeeded.

Local:   http://localhost:4200/
```

### 4. Test the Application (1 minute)

1. Open browser: `http://localhost:4200`
2. You'll see the login page
3. **Register first:**
   - Enter username: `testuser`
   - Enter email: `test@example.com`
   - Enter password: `password123`
   - Click "Register"

4. **Then Login:**
   - Enter username: `testuser`
   - Enter password: `password123`
   - Click "Login"

5. You'll see the dashboard with your user information

---

## Database Information

### Automatic Setup
- Database name: `DotNetAngularDb`
- Tables: `Users`
- Created automatically when backend starts
- Migrations applied automatically

### Users Table Structure
```
Id              int          (Auto-increment)
Username        nvarchar(100) (Unique)
Email           nvarchar(255) (Unique)
PasswordHash    nvarchar(max) (SHA256 hashed)
CreatedAt       datetime2     (Account creation time)
LastLogin       datetime2     (Last login time, nullable)
IsActive        bit           (Account status, default: 1)
```

### Connection String Options

**Windows Authentication (Recommended for Local Development):**
```
Server=localhost;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;
```

**SQL Server Authentication:**
```
Server=YOUR_SERVER;Database=DotNetAngularDb;User Id=sa;Password=YOUR_PASSWORD;TrustServerCertificate=true;Encrypt=false;
```

**Azure SQL Database:**
```
Server=YOUR_SERVER.database.windows.net;Database=DotNetAngularDb;User Id=username;Password=YOUR_PASSWORD;TrustServerCertificate=false;Encrypt=true;
```

---

## API Testing

### Register User
```bash
curl -X POST https://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"newuser","email":"new@example.com","password":"password123"}'
```

### Login
```bash
curl -X POST https://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"newuser","password":"password123"}'
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "newuser",
    "email": "new@example.com"
  }
}
```

---

## Project Structure

```
C:\dotnet-angular\
├── Backend\                          # .NET 9 API with SQL Server
│   ├── Controllers\AuthController.cs # Login/Register endpoints
│   ├── Data\ApplicationDbContext.cs  # Entity Framework Core DbContext
│   ├── Models\User.cs               # User entity
│   ├── Services\AuthService.cs      # Authentication logic
│   ├── Migrations\                  # Database migrations
│   ├── Database\Setup.sql           # Manual setup script
│   ├── appsettings.json             # Configuration
│   ├── Program.cs                   # Startup configuration
│   └── Backend.csproj               # Project file
│
├── Frontend\                         # Angular 19 Application
│   ├── src\app\
│   │   ├── components\
│   │   │   ├── login\               # Login page
│   │   │   └── dashboard\           # Protected dashboard
│   │   ├── services\
│   │   │   └── auth.service.ts      # Authentication service
│   │   ├── app.routes.ts            # Routing configuration
│   │   └── app.config.ts            # App configuration
│   ├── angular.json
│   ├── package.json
│   └── tsconfig.json
│
├── README.md                        # Full documentation
└── DATABASE_SETUP.md                # Database setup guide
```

---

## Common Tasks

### View Database Tables

**SQL Server Management Studio:**
1. Connect to your server
2. Navigate to: Databases → DotNetAngularDb → Tables
3. Right-click Tables → Refresh
4. Expand to see the Users table

**Query Users:**
```sql
USE DotNetAngularDb;
SELECT * FROM Users;
```

### Reset Database

**Option 1: Delete and Recreate**
1. Open SQL Server Management Studio
2. Right-click `DotNetAngularDb` database
3. Select "Delete"
4. Restart the backend to recreate

**Option 2: Clear Users Table**
```sql
USE DotNetAngularDb;
DELETE FROM Users;
DBCC CHECKIDENT ('Users', RESEED, 0);
```

### Change JWT Expiration

Edit `Backend/appsettings.json`:
```json
{
  "Jwt": {
    "ExpirationMinutes": 120
  }
}
```

### Change Database Name

1. Update connection string in `Backend/appsettings.json`
2. Update both `appsettings.json` and `appsettings.Development.json`
3. Restart backend

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Cannot connect to SQL Server" | Verify SQL Server is running and connection string is correct |
| "Port 5001 already in use" | Change port in `launchSettings.json` or kill process using port |
| "Port 4200 already in use" | Run `ng serve --port 4300` |
| "Database creation failed" | Check SQL Server permissions, ensure you can create databases |
| "Login fails with valid credentials" | Verify database was created with Users table |
| "CORS errors in browser console" | Ensure backend is running on https://localhost:5001 |
| "Angular won't start" | Run `npm install` then `ng serve` |

---

## Next Steps

1. ✅ Read [README.md](README.md) for complete documentation
2. ✅ Review [DATABASE_SETUP.md](Backend/DATABASE_SETUP.md) for advanced database setup
3. ✅ Check security recommendations in README.md
4. ✅ Add more features (password reset, email verification, etc.)
5. ✅ Deploy to production (Azure, AWS, Docker, etc.)

---

## Key Features Implemented

✅ User Registration with email validation  
✅ User Login with JWT tokens  
✅ Password hashing with SHA256  
✅ SQL Server database integration  
✅ Entity Framework Core with automatic migrations  
✅ Protected dashboard route  
✅ User profile display  
✅ Logout functionality  
✅ CORS configured for local development  
✅ Responsive UI design  

---

**Happy coding! 🚀**

For detailed information, see [README.md](README.md)

