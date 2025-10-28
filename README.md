# .NET Angular Login Application with SQL Server

A full-stack web application with a .NET 9 backend API and Angular frontend, featuring JWT-based authentication, user registration, and SQL Server database integration.

## Project Structure

```
dotnet-angular/
├── Backend/              # ASP.NET Core 9 Web API with SQL Server
│   ├── Controllers/      # API endpoints (AuthController)
│   ├── Data/            # Entity Framework Core DbContext
│   ├── Models/          # Data models (User, LoginRequest, LoginResponse)
│   ├── Services/        # Business logic (AuthService with JWT and password hashing)
│   ├── Migrations/      # Database migrations
│   ├── Database/        # SQL setup scripts
│   ├── Program.cs       # Application configuration
│   └── appsettings*.json # Configuration files
└── Frontend/            # Angular standalone application
    ├── src/
    │   └── app/
    │       ├── components/
    │       │   ├── login/      # Login page component
    │       │   └── dashboard/  # Dashboard component (protected)
    │       ├── services/
    │       │   └── auth.service.ts  # Authentication service
    │       ├── app.routes.ts   # Application routing
    │       └── app.config.ts   # Application configuration
    └── package.json
```

## Features

✅ **Backend (ASP.NET Core 9 with SQL Server)**
- SQL Server database integration with Entity Framework Core
- User registration with email validation
- Password hashing using SHA256
- JWT token generation and validation
- RESTful API endpoints for login and registration
- CORS enabled for Angular frontend
- Automatic database migrations
- User login tracking (LastLogin timestamp)
- Account activation status

✅ **Frontend (Angular)**
- Standalone components with standalone API
- Login form with form validation
- User registration form
- JWT token storage in localStorage
- Protected dashboard route
- User profile display
- Logout functionality
- Clean, responsive UI with CSS styling
- Angular routing with route protection

## Prerequisites

- **.NET SDK 9.0** or later
- **SQL Server 2019+** or SQL Server Express
- **Node.js 18+** and npm
- A terminal or command prompt

## Quick Start - 3 Steps

### Step 1: Database Setup

**Option A: Automatic (Recommended)**
The database will be created automatically when you run the backend for the first time.

**Option B: Manual**
1. Open SQL Server Management Studio
2. Execute the script: `Backend\Database\Setup.sql`

For detailed database setup, see [DATABASE_SETUP.md](Backend/DATABASE_SETUP.md)

### Step 2: Run Backend

```bash
cd Backend
dotnet run
```

Backend will start on `https://localhost:5001`

### Step 3: Run Frontend

In a new terminal:
```bash
cd Frontend
ng serve
```

Frontend will start on `http://localhost:4200`

---

## Installation & Detailed Setup

### Backend Setup

1. Navigate to the Backend directory:
```bash
cd Backend
```

2. Restore dependencies:
```bash
dotnet restore
```

3. Verify SQL Server connection (update `appsettings.json` if needed)

4. Build the project:
```bash
dotnet build
```

5. Run the backend server:
```bash
dotnet run
```

The backend will:
- Start on `https://localhost:5001`
- Create database `DotNetAngularDb` if it doesn't exist
- Apply migrations automatically
- Expose API endpoints on `/api/auth`

### Frontend Setup

1. In a new terminal, navigate to the Frontend directory:
```bash
cd Frontend
```

2. Install dependencies (if not already installed):
```bash
npm install
```

3. Start the development server:
```bash
ng serve
```

The frontend will start on `http://localhost:4200`

## Usage

### Register New User

1. Open `http://localhost:4200` in your browser
2. Click "Register" (if available) or go to `/register`
3. Fill in username, email, and password
4. Click "Register" button
5. You'll be prompted to login

### Login

1. Go to login page
2. Enter your username and password
3. Click "Login"
4. On successful login, you'll be redirected to the dashboard

### Dashboard

After logging in:
- View your user information (ID, Username, Email)
- See your account creation date
- View last login timestamp
- Click "Logout" to sign out

## API Endpoints

### Authentication Endpoints

#### POST /api/auth/register
Register a new user account.

**Request:**
```json
{
  "username": "newuser",
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Registration successful. You can now login."
}
```

**Response (Failure - 400):**
```json
{
  "success": false,
  "message": "Registration failed. Username or email may already exist."
}
```

#### POST /api/auth/login
Authenticate a user and receive JWT token.

**Request:**
```json
{
  "username": "newuser",
  "password": "securepassword"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "newuser",
    "email": "user@example.com"
  }
}
```

**Response (Failure - 401):**
```json
{
  "success": false,
  "message": "Invalid username or password"
}
```

#### POST /api/auth/validate
Validate JWT token.

**Request:**
```json
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Response:**
```json
{
  "isValid": true
}
```

## Database

### SQL Server Configuration

The application uses the following configuration in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DotNetAngularDb;Trusted_Connection=true;TrustServerCertificate=true;Encrypt=false;"
  }
}
```

### Database Schema

**Users Table:**
- `Id` (int, Primary Key, Auto-increment)
- `Username` (nvarchar(100), Unique, Required)
- `Email` (nvarchar(255), Unique, Required)
- `PasswordHash` (nvarchar(max), Required) - SHA256 hash
- `CreatedAt` (datetime2, Default: UTC now)
- `LastLogin` (datetime2, Nullable)
- `IsActive` (bit, Default: 1)

### Entity Framework Core

The application uses Entity Framework Core with automatic migrations:

```bash
# View migrations
dotnet ef migrations list

# Create new migration
dotnet ef migrations add MigrationName

# Update database
dotnet ef database update
```

For more details, see [DATABASE_SETUP.md](Backend/DATABASE_SETUP.md)

## Architecture

### Backend Architecture

**AuthService**: Handles authentication logic
- `Login()`: Validates credentials and generates JWT token
- `Register()`: Creates new user with hashed password
- `ValidateToken()`: Verifies JWT token validity
- `GenerateJwtToken()`: Creates JWT with expiration
- `HashPassword()`: SHA256 password hashing
- `VerifyPassword()`: Compares password with stored hash

**AuthController**: RESTful API endpoints
- `POST /api/auth/login`: User login
- `POST /api/auth/register`: User registration
- `POST /api/auth/validate`: Token validation

**ApplicationDbContext**: Entity Framework Core DbContext
- Manages User entity
- Configures unique constraints on Username and Email
- Auto-migration on application startup

### Frontend Architecture

**AuthService**: Reactive authentication state management
- Uses BehaviorSubject for state
- Stores JWT token in localStorage
- Provides Observable streams for components
- Handles login/logout/registration

**LoginComponent**: User login interface
- Form validation
- Error handling
- Loading states
- Auto-redirect if already logged in

**DashboardComponent**: Protected user area
- Requires authentication
- Displays user information
- Logout functionality
- Auto-redirect if unauthorized

## Security Features

✅ **Password Security**
- Passwords hashed using SHA256
- Never stored in plain text
- Verified on every login

✅ **JWT Tokens**
- Configured expiration (default: 60 minutes)
- Signed with secure key
- Stored in secure storage

✅ **User Validation**
- Unique username and email constraints
- Active/inactive account status
- Login timestamp tracking

⚠️ **Production Recommendations**

1. **Upgrade Password Hashing**:
   - Replace SHA256 with bcrypt or Argon2
   ```csharp
   // Use BCrypt.Net-Next package
   using BCrypt.Net;
   var hash = BCrypt.HashPassword(password);
   ```

2. **Enhance JWT Security**:
   - Use strong secret keys (256-bit minimum)
   - Implement refresh token rotation
   - Add token blacklisting for logout
   - Set `ValidateIssuer` and `ValidateAudience`

3. **HTTPS/TLS**:
   - Always use HTTPS in production
   - Set `Secure` flag on cookies
   - Set `HttpOnly` flag on auth cookies

4. **CORS Configuration**:
   - Restrict to specific domains
   ```csharp
   policy.WithOrigins("https://yourdomain.com")
   ```

5. **Database Security**:
   - Use SQL Server Authentication with strong passwords
   - Enable encryption in connection string: `Encrypt=true`
   - Implement row-level security (RLS)
   - Regular backups and monitoring

6. **Input Validation**:
   - Validate all inputs on server-side
   - Use data annotations
   - Sanitize user input

7. **Error Handling**:
   - Don't expose sensitive information
   - Implement comprehensive logging
   - Monitor failed login attempts

## Troubleshooting

### Backend Issues

**"Cannot connect to SQL Server"**
- Verify SQL Server is running
- Check connection string in appsettings.json
- Ensure server name/port is correct
- See [DATABASE_SETUP.md](Backend/DATABASE_SETUP.md) for details

**"Build failed with errors"**
```bash
dotnet clean
dotnet restore
dotnet build
```

**"Database migration error"**
- Delete the database in SSMS
- Run the backend again to recreate
- Or manually run `Database\Setup.sql`

### Frontend Issues

**"Cannot connect to backend"**
- Verify backend is running on https://localhost:5001
- Check browser console for CORS errors (F12)
- Ensure Angular is on http://localhost:4200

**"Build or serve fails"**
```bash
npm cache clean --force
rm -r node_modules
npm install
ng serve
```

**"Module not found errors"**
```bash
npm install
ng serve
```

## Project Configuration Files

### Backend Configuration

**appsettings.json** (Production):
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DotNetAngularDb;..."
  },
  "Jwt": {
    "SecretKey": "your-secure-key-here",
    "ExpirationMinutes": 60
  }
}
```

**appsettings.Development.json** (Development):
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=DotNetAngularDb;..."
  }
}
```

### Frontend Configuration

**angular.json**: Build and serve configuration
**tsconfig.json**: TypeScript compiler options
**package.json**: npm dependencies

## Next Steps for Production

1. ✅ Add unit and integration tests
2. ✅ Implement email verification for registration
3. ✅ Add password reset functionality
4. ✅ Implement role-based access control (RBAC)
5. ✅ Add two-factor authentication (2FA)
6. ✅ Set up audit logging
7. ✅ Configure production deployment
8. ✅ Set up CI/CD pipeline
9. ✅ Implement comprehensive error handling
10. ✅ Add API rate limiting

## Additional Resources

- [DATABASE_SETUP.md](Backend/DATABASE_SETUP.md) - Detailed database configuration
- [ASP.NET Core Documentation](https://docs.microsoft.com/en-us/aspnet/core)
- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core)
- [Angular Documentation](https://angular.io/docs)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)

---

**Version**: 1.0  
**Last Updated**: October 2025  
**Framework Versions**: .NET 9.0, Angular 19.x, SQL Server 2019+

