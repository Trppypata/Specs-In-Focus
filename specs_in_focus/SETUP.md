# Specs In Focus - Setup Instructions

This project consists of a Flutter app frontend and a Node.js/PostgreSQL backend.

## Prerequisites

1. Flutter SDK (latest version)
2. Node.js (v14+ recommended)
3. PostgreSQL database
4. Android Studio / VS Code with Flutter extensions

## Setting Up the Backend

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a PostgreSQL database named `specs_in_focus_db`

4. Create a `.env` file in the backend directory with the following variables:
   ```
   PORT=5000
   DB_HOST=localhost
   DB_USER=postgres
   DB_PASSWORD=your_password
   DB_NAME=specs_in_focus_db
   DB_PORT=5432
   JWT_SECRET=your_jwt_secret_key
   ```

5. Start the development server:
   ```
   npm run dev
   ```

## Setting Up the Flutter App

1. Install Flutter dependencies:
   ```
   flutter pub get
   ```

2. Update the API URL in `lib/services/api_service.dart` if needed:
   - For local Android emulator: `static const String baseUrl = 'http://10.0.2.2:5000/api';`
   - For iOS simulator: `static const String baseUrl = 'http://localhost:5000/api';`
   - For physical device: Use your computer's IP address: `static const String baseUrl = 'http://192.168.x.x:5000/api';`

3. Run the Flutter application:
   ```
   flutter run
   ```

## Access on Different Platforms

### Android
- Use `flutter run -d android` to run on a connected Android device
- Or open an Android emulator and run `flutter run`

### iOS
- Use `flutter run -d ios` to run on a connected iOS device
- Or open an iOS simulator and run `flutter run`

### Web
- Use `flutter run -d chrome` to run in Chrome browser
- Or `flutter run -d web-server` to run on a web server

### Windows
- Use `flutter run -d windows` to run as a Windows desktop app
  - Note: Requires Visual Studio with "Desktop development with C++" workload installed

## Backend API Routes

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login a user
- `GET /api/auth/me` - Get current user profile (requires authentication)

### Users
- `GET /api/users` - Get all users (admin only)
- `GET /api/users/:id` - Get a specific user by ID
- `PUT /api/users/:id` - Update a user
- `DELETE /api/users/:id` - Delete a user (admin only)

## Troubleshooting

### Flutter Build Issues
- If Flutter build is taking too long, try:
  - `flutter clean` and then `flutter pub get`
  - Use `flutter run --fast-start` for faster startup

### Backend Connection Issues
- Ensure your PostgreSQL service is running
- Verify the database credentials in the `.env` file
- Check that the port isn't blocked by a firewall

### API Connection Issues
- Verify the correct baseUrl in `api_service.dart`
- For Android emulator, use 10.0.2.2 instead of localhost
- For physical devices, ensure they're on the same network as the backend server 