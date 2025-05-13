# Specs In Focus Backend

A Node.js backend API for the Specs In Focus Flutter application.

## Technologies Used

- Node.js
- Express.js
- PostgreSQL
- Sequelize ORM
- JWT Authentication
- bcryptjs for password hashing

## Getting Started

### Prerequisites

1. Node.js (v14+ recommended)
2. PostgreSQL database

### Installation

1. Install dependencies:
   ```
   npm install
   ```

2. Create a PostgreSQL database named `specs_in_focus_db`

3. Create a `.env` file in the root of the backend directory with the following variables:
   ```
   PORT=5000
   DB_HOST=localhost
   DB_USER=postgres
   DB_PASSWORD=your_password
   DB_NAME=specs_in_focus_db
   DB_PORT=5432
   JWT_SECRET=your_jwt_secret_key
   ```

4. Start the development server:
   ```
   npm run dev
   ```

## API Routes

### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login a user
- `GET /api/auth/me` - Get current user profile (requires authentication)

### Users

- `GET /api/users` - Get all users (admin only)
- `GET /api/users/:id` - Get a specific user by ID
- `PUT /api/users/:id` - Update a user
- `DELETE /api/users/:id` - Delete a user (admin only)

## Authentication

The API uses JWT tokens for authentication. To access protected routes, include the token in the Authorization header:

```
Authorization: Bearer YOUR_TOKEN
``` 