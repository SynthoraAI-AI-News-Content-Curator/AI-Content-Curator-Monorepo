# Architecture Documentation

## Overview

AI Content Curator is a **monorepo-based** microservices architecture built with modern web technologies. It aggregates, curates, and delivers AI-related news content through multiple channels.

## Table of Contents

- [System Architecture](#system-architecture)
- [Monorepo Structure](#monorepo-structure)
- [Services](#services)
- [Data Flow](#data-flow)
- [Technology Stack](#technology-stack)
- [Database Schema](#database-schema)
- [Security Architecture](#security-architecture)
- [Scalability](#scalability)
- [Infrastructure](#infrastructure)

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Layer                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Web UI  │  │  Mobile  │  │   CLI    │  │   API    │      │
│  │ (Next.js)│  │ (Future) │  │  (aicc)  │  │ Clients  │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                      API Gateway Layer                          │
│              (Next.js API Routes + Express.js)                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Authentication  │  Rate Limiting  │  CORS  │  Logging │    │
│  └────────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                      Service Layer                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Backend  │  │ Crawler  │  │Newsletter│  │   AI     │      │
│  │ Service  │  │ Service  │  │ Service  │  │ Service  │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                      Data Layer                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ MongoDB  │  │  Redis   │  │ External │  │   Logs   │      │
│  │ (Primary)│  │ (Cache)  │  │   APIs   │  │(Winston) │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────────────────────┘
```

### Component Interaction

```
┌──────────┐      ┌──────────┐      ┌──────────┐
│          │      │          │      │          │
│ Frontend │─────▶│ Backend  │◀─────│ Crawler  │
│          │ HTTP │   API    │ DB   │  Service │
└──────────┘      └────┬─────┘      └──────────┘
                       │                   │
                       ▼                   ▼
                  ┌─────────┐         ┌─────────┐
                  │ MongoDB │         │  Redis  │
                  └─────────┘         └─────────┘
                       ▲                   ▲
                       │                   │
                  ┌────┴─────┐        ┌────┴─────┐
                  │Newsletter│        │    AI    │
                  │ Service  │        │ Service  │
                  └──────────┘        └──────────┘
```

---

## Monorepo Structure

### Workspace Organization

```
AI-Content-Curator-Monorepo/
├── backend/              # Backend API service
│   ├── src/
│   │   ├── models/      # MongoDB schemas
│   │   ├── routes/      # Express routes
│   │   ├── services/    # Business logic
│   │   ├── middleware/  # Auth, validation, etc.
│   │   └── pages/api/   # Next.js API routes
│   └── package.json
│
├── frontend/            # User-facing web application
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── pages/       # Next.js pages
│   │   ├── lib/         # Utilities & API clients
│   │   └── styles/      # CSS/SCSS files
│   └── package.json
│
├── crawler/             # Web scraping service
│   ├── services/        # Scraping logic
│   ├── scripts/         # Automation scripts
│   └── package.json
│
├── newsletters/         # Email newsletter service
│   ├── services/        # Email sending logic
│   ├── templates/       # Email templates
│   └── package.json
│
├── python_crawler/      # Alternative Python scraper
│   ├── src/
│   └── requirements.txt
│
├── bin/                 # CLI tools
│   └── aicc.js         # Command-line interface
│
└── shell/              # Shell automation scripts
```

### Workspace Dependencies

```
┌─────────────────────────────────────────────┐
│           Root Workspace                    │
│         (npm workspaces)                    │
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐   │
│  │ Backend │  │Frontend │  │ Crawler │   │
│  │         │  │         │  │         │   │
│  └────┬────┘  └────┬────┘  └────┬────┘   │
│       │            │            │         │
│       └────────────┴────────────┘         │
│                    │                      │
│            Shared Dependencies           │
│      (TypeScript, ESLint, etc.)         │
└─────────────────────────────────────────────┘
```

---

## Services

### 1. Backend Service

**Purpose**: Core API and business logic

**Technology**: Express.js + Next.js

**Responsibilities**:
- User authentication & authorization
- Article CRUD operations
- Comment management
- Favorites system
- Chat/Q&A with AI
- API documentation (Swagger)

**Key Files**:
- `/backend/src/index.ts` - Express app initialization
- `/backend/src/routes/*.ts` - API route handlers
- `/backend/src/services/*.ts` - Business logic
- `/backend/src/models/*.ts` - Database schemas

**Deployment**: Vercel (serverless functions)

---

### 2. Frontend Service

**Purpose**: User interface

**Technology**: Next.js 15 + React 19

**Responsibilities**:
- Article browsing & search
- User authentication UI
- Comments & discussions
- Newsletter subscription
- Favorites management
- Dark/light theme toggle
- Responsive design

**Key Features**:
- **SSG**: Static generation for article pages
- **SSR**: Server-side rendering for dynamic content
- **ISR**: Incremental static regeneration
- **Client-side**: Interactive features (chat, comments)

**Key Files**:
- `/frontend/src/pages/*.tsx` - Page components
- `/frontend/src/components/*.tsx` - Reusable components
- `/frontend/src/lib/apiClient.ts` - API communication

**Deployment**: Vercel (Edge Network)

---

### 3. Crawler Service

**Purpose**: Web scraping & content aggregation

**Technology**: Node.js + Puppeteer/Cheerio

**Responsibilities**:
- Fetch articles from multiple sources
- Extract metadata (title, content, images)
- Summarize content using AI
- Extract topics/tags
- Store articles in database

**Scraping Strategies**:
1. **Static HTML** (Cheerio): Fast, for simple pages
2. **Dynamic Content** (Puppeteer): For JavaScript-heavy sites

**Sources**:
- Government websites (state.gov, whitehouse.gov)
- News APIs (NewsAPI)
- Custom RSS feeds
- Manual URL submission

**Scheduling**:
- Daily crawl: 6 AM & 6 PM UTC (Vercel Cron)
- Manual trigger via API

**Key Files**:
- `/crawler/services/crawler.service.ts` - Main crawler logic
- `/crawler/services/summarization.service.ts` - AI summarization
- `/crawler/scripts/fetchLatestArticles.ts` - Automation script

**Deployment**: Vercel (scheduled functions)

---

### 4. Newsletter Service

**Purpose**: Email newsletter distribution

**Technology**: Node.js + Resend API

**Responsibilities**:
- Manage email subscriptions
- Generate daily newsletter content
- Send emails via Resend
- Handle unsubscriptions

**Newsletter Content**:
- Latest 10 articles
- AI-generated summaries
- Topic categorization
- Links to full articles

**Scheduling**:
- Daily send: 9 AM UTC (Vercel Cron)

**Key Files**:
- `/newsletters/services/newsletterService.ts` - Email generation
- `/newsletters/templates/` - Email templates

**Deployment**: Vercel (scheduled functions)

---

### 5. AI Service

**Purpose**: AI-powered features

**Technology**: Google Generative AI (Gemini)

**Responsibilities**:
- Content summarization
- Topic extraction
- Q&A chatbot (RAG-based)
- Content recommendation (future)

**AI Workflows**:

#### Summarization
```
Article Text → Gemini API → Summary (3-5 sentences)
```

#### Q&A (RAG)
```
User Question → Embedding → Vector Search → Context
              ↓
         Gemini API (with context) → Answer
```

**Key Files**:
- `/backend/src/services/summarization.service.ts`
- `/backend/src/services/topicExtractor.service.ts`
- `/backend/src/services/chatService.ts` (RAG implementation)

---

## Data Flow

### Article Creation Flow

```
1. Crawler Service
   ↓ Fetch URL
2. Extract Content (Cheerio/Puppeteer)
   ↓
3. AI Service (Summarize + Extract Topics)
   ↓
4. Save to MongoDB
   ↓
5. Cache in Redis (frequently accessed)
   ↓
6. Frontend displays via API
```

### User Authentication Flow

```
1. User submits credentials (Frontend)
   ↓
2. Backend validates (bcrypt password check)
   ↓
3. Generate JWT tokens (access + refresh)
   ↓
4. Store refresh token in MongoDB
   ↓
5. Return tokens (HTTP-only cookies)
   ↓
6. Frontend stores access token
   ↓
7. Include in subsequent requests (Authorization header)
```

### Newsletter Flow

```
1. Vercel Cron triggers (9 AM UTC)
   ↓
2. Newsletter Service fetches latest articles
   ↓
3. Generate HTML email template
   ↓
4. Fetch active subscribers from MongoDB
   ↓
5. Send emails via Resend API (batch)
   ↓
6. Log delivery status
```

---

## Technology Stack

### Frontend

| Component | Technology |
|-----------|-----------|
| Framework | Next.js 15.2.1 |
| UI Library | React 19.0.0 |
| Styling | Tailwind CSS 4.x, Sass |
| State Management | React Context + Hooks |
| Animations | Framer Motion |
| Icons | React Icons, Lucide React |
| Carousel | React Slick |
| HTTP Client | Axios |

### Backend

| Component | Technology |
|-----------|-----------|
| Framework | Express.js 4.18.2 + Next.js |
| Language | TypeScript 5.x |
| Runtime | Node.js 18.x |
| Authentication | JWT + bcrypt |
| Validation | Express Validator |
| Logging | Winston |
| API Docs | Swagger (OpenAPI) |

### Database

| Component | Technology |
|-----------|-----------|
| Primary DB | MongoDB 6.x (Atlas) |
| ODM | Mongoose 6.x |
| Caching | Redis |

### AI/ML

| Component | Technology |
|-----------|-----------|
| AI Model | Google Generative AI (Gemini) |
| Use Cases | Summarization, Topic Extraction, Q&A |

### DevOps

| Component | Technology |
|-----------|-----------|
| Containerization | Docker + Docker Compose |
| CI/CD | GitHub Actions |
| Deployment | Vercel |
| Monitoring | Vercel Analytics |
| Scheduling | Vercel Cron |

---

## Database Schema

### Collections

#### Users
```typescript
{
  _id: ObjectId,
  username: string (unique),
  email: string (unique, indexed),
  password: string (bcrypt hashed),
  favorites: ObjectId[] (references Articles),
  refreshTokens: string[],
  createdAt: Date,
  updatedAt: Date
}
```

#### Articles
```typescript
{
  _id: ObjectId,
  title: string (indexed),
  url: string (unique, indexed),
  summary: string,
  content: string (optional),
  topics: string[] (indexed),
  source: string,
  imageUrl: string,
  publishedAt: Date (indexed),
  createdAt: Date,
  updatedAt: Date
}
```

#### Comments
```typescript
{
  _id: ObjectId,
  articleId: ObjectId (indexed, references Articles),
  userId: ObjectId (indexed, references Users),
  username: string,
  content: string,
  upvotes: number (default: 0),
  downvotes: number (default: 0),
  createdAt: Date,
  updatedAt: Date
}
```

#### ChatSessions
```typescript
{
  _id: ObjectId,
  userId: ObjectId (references Users),
  articleId: ObjectId (references Articles),
  sessionId: string (indexed),
  messages: [
    {
      role: 'user' | 'assistant',
      content: string,
      timestamp: Date
    }
  ],
  createdAt: Date,
  updatedAt: Date
}
```

#### NewsletterSubscribers
```typescript
{
  _id: ObjectId,
  email: string (unique, indexed),
  isActive: boolean (default: true),
  subscribedAt: Date,
  unsubscribedAt: Date (optional)
}
```

### Indexes

```javascript
// Users
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ username: 1 }, { unique: true });

// Articles
db.articles.createIndex({ url: 1 }, { unique: true });
db.articles.createIndex({ title: "text" });
db.articles.createIndex({ topics: 1 });
db.articles.createIndex({ publishedAt: -1 });

// Comments
db.comments.createIndex({ articleId: 1 });
db.comments.createIndex({ userId: 1 });

// ChatSessions
db.chatSessions.createIndex({ sessionId: 1 });
db.chatSessions.createIndex({ userId: 1, articleId: 1 });

// NewsletterSubscribers
db.newsletterSubscribers.createIndex({ email: 1 }, { unique: true });
```

---

## Security Architecture

### Authentication Layers

```
┌────────────────────────────────────────┐
│     1. HTTP-only Cookies               │
│        (Refresh Token)                 │
├────────────────────────────────────────┤
│     2. JWT Access Token                │
│        (Bearer Authorization)          │
├────────────────────────────────────────┤
│     3. Middleware Verification         │
│        (Token validation)              │
├────────────────────────────────────────┤
│     4. Route-level Authorization       │
│        (User ownership checks)         │
└────────────────────────────────────────┘
```

### Security Measures

1. **Password Security**
   - bcrypt hashing (10 rounds)
   - No plain text storage
   - Password strength validation

2. **Token Security**
   - Short-lived access tokens (1 hour)
   - Refresh token rotation
   - Token revocation on logout

3. **API Security**
   - CORS with whitelist
   - Rate limiting
   - Input validation & sanitization
   - Helmet.js security headers

4. **Database Security**
   - MongoDB Atlas (encrypted at rest)
   - TLS/SSL connections
   - Parameterized queries (Mongoose)

5. **Environment Security**
   - All secrets in environment variables
   - `.env` files git-ignored
   - Secret rotation procedures

---

## Scalability

### Horizontal Scaling

```
              Load Balancer
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
   Instance 1  Instance 2  Instance 3
   (Vercel)    (Vercel)    (Vercel)
       │           │           │
       └───────────┼───────────┘
                   │
              MongoDB Atlas
           (Auto-scaling cluster)
```

### Caching Strategy

```
Request → Cache Check (Redis)
           ├─ Hit → Return cached data
           └─ Miss → Fetch from MongoDB
                      → Cache result (TTL: 1 hour)
                      → Return data
```

### Performance Optimizations

1. **Database**
   - Indexed queries
   - Aggregation pipelines
   - Connection pooling

2. **Caching**
   - Redis for frequently accessed data
   - Browser caching (static assets)
   - CDN (Vercel Edge Network)

3. **Frontend**
   - Code splitting
   - Lazy loading
   - Image optimization (Next.js Image)
   - Static generation (SSG)

4. **API**
   - Pagination
   - Field selection
   - Response compression

---

## Infrastructure

### Development Environment

```
Docker Compose
├── MongoDB (port 27017)
├── Redis (port 6379)
├── Backend (port 3001)
├── Frontend (port 3000)
├── Crawler (port 3002)
└── Newsletter (port 3003)
```

### Production Environment (Vercel)

```
Vercel Platform
├── Frontend (Edge Network, SSR + SSG)
├── Backend (Serverless Functions)
├── Crawler (Scheduled Functions)
└── Newsletter (Scheduled Functions)

External Services
├── MongoDB Atlas (Database)
├── Redis Cloud (Caching)
├── Google AI (Gemini API)
├── Resend (Email delivery)
└── NewsAPI (Content source)
```

### CI/CD Pipeline

```
Git Push → GitHub
    ↓
GitHub Actions
    ├─ Lint & Format
    ├─ Type Check
    ├─ Unit Tests
    ├─ Build
    └─ E2E Tests
    ↓
Merge to Main
    ↓
Vercel Auto-Deploy
    ├─ Build
    ├─ Deploy
    └─ Health Checks
```

---

## Future Enhancements

### Planned Architecture Changes

1. **Microservices Migration**
   - Separate services into independent deployments
   - API Gateway (Kong/Nginx)
   - Service mesh (Istio)

2. **Event-Driven Architecture**
   - Message queue (RabbitMQ/Kafka)
   - Event sourcing for article updates
   - Real-time notifications (WebSockets)

3. **Advanced Caching**
   - Multi-layer caching (L1: Memory, L2: Redis, L3: CDN)
   - Invalidation strategies

4. **Observability**
   - Distributed tracing (OpenTelemetry)
   - Metrics (Prometheus + Grafana)
   - Centralized logging (ELK stack)

5. **Machine Learning Pipeline**
   - Recommendation engine
   - Content classification
   - User preference modeling

---

## References

- [Next.js Documentation](https://nextjs.org/docs)
- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Vercel Platform](https://vercel.com/docs)
- [Google Generative AI](https://ai.google.dev/)

---

**Last Updated**: 2025-11-13
