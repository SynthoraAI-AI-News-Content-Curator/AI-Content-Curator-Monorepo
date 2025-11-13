# API Documentation

Complete API reference for the AI Content Curator backend services.

## Table of Contents

- [Base URL](#base-url)
- [Authentication](#authentication)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Endpoints](#endpoints)
  - [Authentication](#authentication-endpoints)
  - [Articles](#articles-endpoints)
  - [Comments](#comments-endpoints)
  - [Chat/Q&A](#chatqa-endpoints)
  - [Newsletter](#newsletter-endpoints)
  - [User](#user-endpoints)

## Base URL

```
Development: http://localhost:3000/api
Production: https://your-domain.com/api
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication.

### Token Types

1. **Access Token**: Short-lived (1 hour), used for API requests
2. **Refresh Token**: Long-lived (7 days), used to obtain new access tokens

### Authentication Flow

```
1. Login/Register → Receive access + refresh tokens
2. Include access token in requests
3. When access token expires → Use refresh token to get new access token
4. When refresh token expires → Login again
```

### Including Tokens in Requests

**Method 1: HTTP-only Cookie (Recommended)**
```javascript
// Tokens are automatically sent via cookies
fetch('/api/articles', {
  credentials: 'include'
});
```

**Method 2: Authorization Header**
```javascript
fetch('/api/articles', {
  headers: {
    'Authorization': `Bearer ${accessToken}`
  }
});
```

## Error Handling

### Error Response Format

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": {} // Optional additional details
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

### Common Error Codes

- `INVALID_CREDENTIALS`: Wrong username/password
- `TOKEN_EXPIRED`: Access token has expired
- `TOKEN_INVALID`: Malformed or invalid token
- `RESOURCE_NOT_FOUND`: Requested resource doesn't exist
- `VALIDATION_ERROR`: Request data validation failed
- `DUPLICATE_ENTRY`: Resource already exists

## Rate Limiting

- **General API**: 100 requests per 15 minutes
- **Authentication**: 5 login attempts per 15 minutes
- **Newsletter**: 10 subscriptions per hour

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000
```

---

## Endpoints

### Authentication Endpoints

#### Register User

Create a new user account.

```http
POST /api/auth/register
```

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePassword123!"
}
```

**Response:** `201 Created`
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "username": "john_doe",
    "email": "john@example.com",
    "favorites": []
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Validation Rules:**
- `username`: 3-30 characters, alphanumeric + underscore
- `email`: Valid email format
- `password`: Min 8 characters

---

#### Login

Authenticate and receive tokens.

```http
POST /api/auth/login
```

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "SecurePassword123!"
}
```

**Response:** `200 OK`
```json
{
  "message": "Login successful",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "username": "john_doe",
    "email": "john@example.com",
    "favorites": ["article_id_1", "article_id_2"]
  },
  "accessToken": "...",
  "refreshToken": "..."
}
```

---

#### Refresh Token

Get a new access token using refresh token.

```http
POST /api/auth/refresh
```

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** `200 OK`
```json
{
  "accessToken": "new_access_token..."
}
```

---

#### Logout

Invalidate tokens.

```http
POST /api/auth/logout
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "message": "Logged out successfully"
}
```

---

#### Password Reset Request

Request a password reset email.

```http
POST /api/auth/forgot-password
```

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response:** `200 OK`
```json
{
  "message": "Password reset email sent"
}
```

---

#### Reset Password

Reset password using token from email.

```http
POST /api/auth/reset-password
```

**Request Body:**
```json
{
  "token": "reset_token_from_email",
  "newPassword": "NewSecurePassword123!"
}
```

**Response:** `200 OK`
```json
{
  "message": "Password reset successful"
}
```

---

### Articles Endpoints

#### Get All Articles

Retrieve paginated articles.

```http
GET /api/articles?page=1&limit=20&topic=technology&search=AI
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)
- `topic` (optional): Filter by topic
- `search` (optional): Search in title and summary

**Response:** `200 OK`
```json
{
  "articles": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "title": "AI Breakthrough in Healthcare",
      "url": "https://example.com/article",
      "summary": "Researchers develop new AI model...",
      "topics": ["AI", "Healthcare", "Technology"],
      "source": "TechNews",
      "imageUrl": "https://example.com/image.jpg",
      "publishedAt": "2025-11-13T10:00:00Z",
      "createdAt": "2025-11-13T10:05:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 10,
    "totalItems": 200,
    "itemsPerPage": 20
  }
}
```

---

#### Get Article by ID

Retrieve a specific article.

```http
GET /api/articles/:id
```

**Response:** `200 OK`
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "AI Breakthrough in Healthcare",
  "url": "https://example.com/article",
  "summary": "Detailed summary...",
  "topics": ["AI", "Healthcare"],
  "source": "TechNews",
  "imageUrl": "https://example.com/image.jpg",
  "publishedAt": "2025-11-13T10:00:00Z",
  "createdAt": "2025-11-13T10:05:00Z"
}
```

---

#### Get All Topics

Retrieve unique topics from all articles.

```http
GET /api/articles/topics
```

**Response:** `200 OK`
```json
{
  "topics": [
    "AI",
    "Healthcare",
    "Technology",
    "Climate",
    "Politics"
  ]
}
```

---

### Comments Endpoints

#### Get Comments for Article

Retrieve all comments for an article.

```http
GET /api/comments/:articleId
```

**Response:** `200 OK`
```json
{
  "comments": [
    {
      "_id": "comment_id_1",
      "articleId": "507f1f77bcf86cd799439011",
      "userId": "user_id_1",
      "username": "john_doe",
      "content": "Great article!",
      "upvotes": 5,
      "downvotes": 1,
      "createdAt": "2025-11-13T11:00:00Z",
      "updatedAt": "2025-11-13T11:00:00Z"
    }
  ]
}
```

---

#### Create Comment

Add a comment to an article.

```http
POST /api/comments
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "articleId": "507f1f77bcf86cd799439011",
  "content": "This is a great article!"
}
```

**Response:** `201 Created`
```json
{
  "comment": {
    "_id": "comment_id",
    "articleId": "507f1f77bcf86cd799439011",
    "userId": "user_id",
    "username": "john_doe",
    "content": "This is a great article!",
    "upvotes": 0,
    "downvotes": 0,
    "createdAt": "2025-11-13T11:30:00Z"
  }
}
```

---

#### Vote on Comment

Upvote or downvote a comment.

```http
POST /api/comments/:commentId/vote
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "voteType": "upvote"  // or "downvote"
}
```

**Response:** `200 OK`
```json
{
  "message": "Vote recorded",
  "comment": {
    "_id": "comment_id",
    "upvotes": 6,
    "downvotes": 1
  }
}
```

---

#### Delete Comment

Delete your own comment.

```http
DELETE /api/comments/:commentId
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "message": "Comment deleted successfully"
}
```

---

### Chat/Q&A Endpoints

#### Ask Question about Article

Ask AI a question about an article using RAG.

```http
POST /api/chat/ask
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "articleId": "507f1f77bcf86cd799439011",
  "question": "What are the main findings of this research?",
  "sessionId": "optional_session_id"  // For conversation continuity
}
```

**Response:** `200 OK`
```json
{
  "answer": "The main findings include...",
  "sessionId": "session_id_for_followup",
  "sources": [
    {
      "text": "Relevant excerpt from article...",
      "relevance": 0.95
    }
  ]
}
```

---

#### Get Chat History

Retrieve chat history for an article.

```http
GET /api/chat/history/:articleId?sessionId=session_id
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "history": [
    {
      "question": "What are the main findings?",
      "answer": "The main findings include...",
      "timestamp": "2025-11-13T12:00:00Z"
    }
  ]
}
```

---

### Newsletter Endpoints

#### Subscribe to Newsletter

Subscribe email to daily newsletter.

```http
POST /api/newsletter/subscribe
```

**Request Body:**
```json
{
  "email": "subscriber@example.com"
}
```

**Response:** `201 Created`
```json
{
  "message": "Successfully subscribed to newsletter",
  "subscriber": {
    "_id": "subscriber_id",
    "email": "subscriber@example.com",
    "subscribedAt": "2025-11-13T13:00:00Z",
    "isActive": true
  }
}
```

---

#### Unsubscribe from Newsletter

Unsubscribe from newsletter.

```http
POST /api/newsletter/unsubscribe
```

**Request Body:**
```json
{
  "email": "subscriber@example.com"
}
```

**Response:** `200 OK`
```json
{
  "message": "Successfully unsubscribed from newsletter"
}
```

---

### User Endpoints

#### Get User Profile

Get current user's profile.

```http
GET /api/users/me
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "user": {
    "_id": "user_id",
    "username": "john_doe",
    "email": "john@example.com",
    "favorites": ["article_id_1", "article_id_2"],
    "createdAt": "2025-11-01T00:00:00Z"
  }
}
```

---

#### Get User Favorites

Get user's favorited articles.

```http
GET /api/users/me/favorites
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "favorites": [
    {
      "_id": "article_id_1",
      "title": "Favorite Article 1",
      "url": "https://example.com/article1",
      "summary": "...",
      "topics": ["AI"]
    }
  ]
}
```

---

#### Add to Favorites

Add an article to favorites.

```http
POST /api/users/me/favorites
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "articleId": "507f1f77bcf86cd799439011"
}
```

**Response:** `200 OK`
```json
{
  "message": "Article added to favorites",
  "favorites": ["article_id_1", "article_id_2", "507f1f77bcf86cd799439011"]
}
```

---

#### Remove from Favorites

Remove an article from favorites.

```http
DELETE /api/users/me/favorites/:articleId
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:** `200 OK`
```json
{
  "message": "Article removed from favorites",
  "favorites": ["article_id_1", "article_id_2"]
}
```

---

#### Update Profile

Update user profile information.

```http
PATCH /api/users/me
```

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "username": "new_username",
  "email": "newemail@example.com"
}
```

**Response:** `200 OK`
```json
{
  "message": "Profile updated successfully",
  "user": {
    "_id": "user_id",
    "username": "new_username",
    "email": "newemail@example.com"
  }
}
```

---

## Swagger/OpenAPI

Interactive API documentation is available at:

```
Development: http://localhost:3000/api-docs
Production: https://your-domain.com/api-docs
```

## Code Examples

### JavaScript/TypeScript

```typescript
// Using fetch with credentials
const response = await fetch('http://localhost:3000/api/articles', {
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json'
  }
});
const data = await response.json();

// Login
const loginResponse = await fetch('http://localhost:3000/api/auth/login', {
  method: 'POST',
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'user@example.com',
    password: 'password123'
  })
});
const { accessToken, user } = await loginResponse.json();

// Protected request
const protectedResponse = await fetch('http://localhost:3000/api/users/me', {
  headers: {
    'Authorization': `Bearer ${accessToken}`
  }
});
```

### Python

```python
import requests

# Login
login_response = requests.post(
    'http://localhost:3000/api/auth/login',
    json={
        'email': 'user@example.com',
        'password': 'password123'
    }
)
tokens = login_response.json()

# Protected request
headers = {'Authorization': f"Bearer {tokens['accessToken']}"}
profile = requests.get(
    'http://localhost:3000/api/users/me',
    headers=headers
)
```

### cURL

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Get articles
curl http://localhost:3000/api/articles?page=1&limit=10

# Protected request
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  http://localhost:3000/api/users/me
```

---

## Webhooks

### Newsletter Subscription Webhook

When enabled, sends webhook on new subscription:

```json
{
  "event": "newsletter.subscribed",
  "data": {
    "email": "subscriber@example.com",
    "subscribedAt": "2025-11-13T13:00:00Z"
  }
}
```

---

## Versioning

Current API version: **v1**

Future versions will be accessible via:
```
/api/v2/...
```

---

## Support

For API issues:
- Check the [Swagger documentation](http://localhost:3000/api-docs)
- Review [GitHub Issues](https://github.com/SynthoraAI-AI-News-Content-Curator/AI-Content-Curator-Monorepo/issues)
- Consult the [README](../README.md)

---

**Last Updated**: 2025-11-13
