# Deployment Guide

Complete guide for deploying the AI Content Curator to various platforms.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Deployment Options](#deployment-options)
  - [Vercel (Recommended)](#vercel-recommended)
  - [Docker](#docker)
  - [Manual Deployment](#manual-deployment)
- [Database Setup](#database-setup)
- [Service Configuration](#service-configuration)
- [Post-Deployment](#post-deployment)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Accounts

1. **MongoDB Atlas** (Database)
   - Sign up at [https://www.mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
   - Create a free cluster (M0)

2. **Vercel** (Deployment - Recommended)
   - Sign up at [https://vercel.com](https://vercel.com)
   - Connect your GitHub account

3. **Google AI** (AI Features)
   - Get API key at [https://ai.google.dev/](https://ai.google.dev/)

4. **Resend** (Email Service)
   - Sign up at [https://resend.com](https://resend.com)
   - Get API key from dashboard

5. **Redis** (Optional, for caching)
   - Use [Redis Cloud](https://redis.com/try-free/) or [Upstash](https://upstash.com/)

### Required Tools

- **Git** 2.x+
- **Node.js** 18.x+
- **npm** 9.x+
- **Docker** (for Docker deployment)

---

## Environment Variables

### Required Variables

Create a `.env` file in the root directory:

```env
# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/ai-content-curator?retryWrites=true&w=majority

# JWT Authentication
JWT_SECRET=your-very-strong-random-secret-here
JWT_REFRESH_SECRET=your-refresh-token-secret-here

# Google Generative AI
GOOGLE_AI_API_KEY=your-google-ai-api-key

# Email Service (Resend)
RESEND_API_KEY=your-resend-api-key
RESEND_FROM_EMAIL=noreply@yourdomain.com

# NewsAPI (Optional, for article fetching)
NEWS_API_KEY=your-newsapi-key

# Redis (Optional, for caching)
REDIS_URL=redis://username:password@host:port

# Application
NODE_ENV=production
API_BASE_URL=https://your-domain.com/api
FRONTEND_URL=https://your-domain.com

# CORS
ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com
```

### Generating Secrets

```bash
# Generate JWT secrets (Node.js)
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# Or using OpenSSL
openssl rand -hex 64
```

### Environment Variables by Service

#### Backend
```env
MONGODB_URI
JWT_SECRET
JWT_REFRESH_SECRET
GOOGLE_AI_API_KEY
RESEND_API_KEY
REDIS_URL (optional)
```

#### Frontend
```env
NEXT_PUBLIC_API_URL
```

#### Crawler
```env
MONGODB_URI
GOOGLE_AI_API_KEY
NEWS_API_KEY
```

#### Newsletter
```env
MONGODB_URI
RESEND_API_KEY
RESEND_FROM_EMAIL
```

---

## Deployment Options

### Vercel (Recommended)

#### 1. Prepare Repository

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/AI-Content-Curator-Monorepo.git
cd AI-Content-Curator-Monorepo

# Install dependencies
npm install
```

#### 2. Deploy Frontend

```bash
# Navigate to Vercel dashboard
# Click "New Project"
# Import your GitHub repository
# Select "frontend" as root directory

# Or use Vercel CLI
cd frontend
vercel --prod
```

**Frontend Configuration:**
- Framework Preset: `Next.js`
- Root Directory: `frontend`
- Build Command: `npm run build`
- Output Directory: `.next`
- Install Command: `npm install`

**Environment Variables** (in Vercel dashboard):
```
NEXT_PUBLIC_API_URL=https://your-backend-url.vercel.app/api
```

#### 3. Deploy Backend

```bash
# In Vercel dashboard
# Create new project for backend
# Root Directory: backend
```

**Backend Configuration:**
- Framework Preset: `Next.js` (for API routes)
- Root Directory: `backend`
- Build Command: `npm run build`
- Output Directory: `dist`

**Environment Variables:**
```
MONGODB_URI=...
JWT_SECRET=...
JWT_REFRESH_SECRET=...
GOOGLE_AI_API_KEY=...
RESEND_API_KEY=...
REDIS_URL=...
```

#### 4. Deploy Crawler

**Crawler Configuration:**
- Root Directory: `crawler`
- Build Command: `npm run build`

**Environment Variables:**
```
MONGODB_URI=...
GOOGLE_AI_API_KEY=...
NEWS_API_KEY=...
```

**Set up Cron Jobs** (in Vercel dashboard):

Go to Settings → Cron Jobs:

```json
{
  "crons": [
    {
      "path": "/api/cron/fetch-articles",
      "schedule": "0 6,18 * * *"
    }
  ]
}
```

#### 5. Deploy Newsletter

**Newsletter Configuration:**
- Root Directory: `newsletters`
- Build Command: `npm run build`

**Environment Variables:**
```
MONGODB_URI=...
RESEND_API_KEY=...
RESEND_FROM_EMAIL=...
```

**Cron Job:**
```json
{
  "crons": [
    {
      "path": "/api/cron/send-newsletter",
      "schedule": "0 9 * * *"
    }
  ]
}
```

#### 6. Custom Domains

In Vercel dashboard:
1. Go to project settings
2. Navigate to "Domains"
3. Add your custom domain
4. Configure DNS records

---

### Docker

#### 1. Install Docker

```bash
# Verify installation
docker --version
docker-compose --version
```

#### 2. Configure Environment

Create `.env` file in root (see [Environment Variables](#environment-variables))

#### 3. Build and Run

```bash
# Build all services
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

#### 4. Access Services

- Frontend: http://localhost:3000
- Backend: http://localhost:3001
- Crawler: http://localhost:3002
- Newsletter: http://localhost:3003
- MongoDB: localhost:27017
- Redis: localhost:6379

#### 5. Production Docker Setup

```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Run in production mode
docker-compose -f docker-compose.prod.yml up -d
```

#### 6. Docker Hub Deployment

```bash
# Tag images
docker tag ai-content-curator-frontend:latest username/ai-content-curator-frontend:latest

# Push to Docker Hub
docker push username/ai-content-curator-frontend:latest

# On production server
docker pull username/ai-content-curator-frontend:latest
docker run -d -p 3000:3000 username/ai-content-curator-frontend:latest
```

---

### Manual Deployment

#### Prerequisites

- Ubuntu 20.04+ or similar Linux distribution
- Node.js 18.x+
- MongoDB 6.x
- Redis (optional)
- Nginx (for reverse proxy)
- PM2 (for process management)

#### 1. Setup Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2
sudo npm install -g pm2

# Install Nginx
sudo apt install -y nginx

# Install MongoDB (or use MongoDB Atlas)
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
```

#### 2. Clone Repository

```bash
cd /var/www
sudo git clone https://github.com/YOUR_USERNAME/AI-Content-Curator-Monorepo.git
cd AI-Content-Curator-Monorepo
sudo chown -R $USER:$USER .
```

#### 3. Install Dependencies

```bash
npm install
```

#### 4. Build Services

```bash
# Build all workspaces
npm run build

# Or build individually
npm run build:backend
npm run build:frontend
npm run build:crawler
npm run build:newsletters
```

#### 5. Configure PM2

Create `ecosystem.config.js`:

```javascript
module.exports = {
  apps: [
    {
      name: 'frontend',
      cwd: './frontend',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      }
    },
    {
      name: 'backend',
      cwd: './backend',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production',
        PORT: 3001
      }
    },
    {
      name: 'crawler',
      cwd: './crawler',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production',
        PORT: 3002
      }
    },
    {
      name: 'newsletter',
      cwd: './newsletters',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production',
        PORT: 3003
      }
    }
  ]
};
```

Start services:

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

#### 6. Configure Nginx

Create `/etc/nginx/sites-available/ai-content-curator`:

```nginx
# Frontend
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Backend API
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/ai-content-curator /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### 7. Setup SSL (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
sudo certbot --nginx -d api.yourdomain.com
```

#### 8. Setup Cron Jobs

```bash
crontab -e

# Add these lines:
# Fetch articles twice daily (6 AM & 6 PM)
0 6,18 * * * cd /var/www/AI-Content-Curator-Monorepo/crawler && npm run fetch:latest

# Send newsletter daily (9 AM)
0 9 * * * cd /var/www/AI-Content-Curator-Monorepo/newsletters && npm run send
```

---

## Database Setup

### MongoDB Atlas

#### 1. Create Cluster

1. Log in to [MongoDB Atlas](https://cloud.mongodb.com)
2. Click "Build a Cluster"
3. Choose FREE tier (M0)
4. Select region closest to your users
5. Click "Create Cluster"

#### 2. Create Database User

1. Go to "Database Access"
2. Click "Add New Database User"
3. Choose "Password" authentication
4. Set username and password
5. Grant "Read and write to any database"

#### 3. Configure Network Access

1. Go to "Network Access"
2. Click "Add IP Address"
3. For development: "Allow Access from Anywhere" (0.0.0.0/0)
4. For production: Add specific IP addresses

#### 4. Get Connection String

1. Click "Connect" on your cluster
2. Choose "Connect your application"
3. Copy connection string
4. Replace `<password>` with your database password
5. Replace `<dbname>` with `ai-content-curator`

---

## Service Configuration

### Vercel Configuration Files

Each service has a `vercel.json`:

**Backend** (`backend/vercel.json`):
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "src/index.ts"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  }
}
```

**Frontend** (`frontend/vercel.json`):
```json
{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install"
}
```

---

## Post-Deployment

### 1. Verify Deployment

```bash
# Check frontend
curl https://your-domain.com

# Check backend API
curl https://api.your-domain.com/api/health

# Check article endpoint
curl https://api.your-domain.com/api/articles
```

### 2. Seed Database (Optional)

```bash
# Run crawler to fetch initial articles
npm run crawler:fetch

# Or manually import data
mongoimport --uri="$MONGODB_URI" --collection=articles --file=articles.json
```

### 3. Test Critical Paths

- [ ] User registration
- [ ] User login
- [ ] Article viewing
- [ ] Comments
- [ ] Favorites
- [ ] Newsletter subscription
- [ ] AI Q&A

### 4. Configure Monitoring

```bash
# Vercel Analytics (automatic)
# View at: https://vercel.com/dashboard/analytics

# PM2 Monitoring (manual deployment)
pm2 monit
pm2 logs
```

---

## Monitoring

### Vercel Monitoring

Access via Vercel dashboard:
- **Analytics**: Traffic, performance
- **Logs**: Real-time function logs
- **Deployments**: Deployment history
- **Metrics**: Response time, error rate

### Custom Monitoring

#### Health Check Endpoint

Add to `backend/src/routes/health.ts`:

```typescript
router.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date(),
    uptime: process.uptime(),
    mongodb: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected'
  });
});
```

#### Uptime Monitoring

Use services like:
- [UptimeRobot](https://uptimerobot.com/)
- [Pingdom](https://www.pingdom.com/)
- [Better Uptime](https://betteruptime.com/)

Set up alerts for:
- HTTP 500 errors
- Response time > 3s
- Downtime > 1 minute

#### Log Management

```bash
# Vercel: View in dashboard
vercel logs

# PM2: View logs
pm2 logs backend
pm2 logs frontend

# Docker: View logs
docker-compose logs -f backend
```

---

## Troubleshooting

### Common Issues

#### 1. Build Failures

**Error**: `Module not found`

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

#### 2. Database Connection Issues

**Error**: `MongoNetworkError`

- Check MongoDB URI in environment variables
- Verify network access in MongoDB Atlas
- Ensure database user has correct permissions

#### 3. Authentication Errors

**Error**: `JWT token invalid`

- Verify `JWT_SECRET` is set correctly
- Ensure clocks are synchronized (for token expiration)
- Check token is being sent in correct format

#### 4. CORS Errors

**Error**: `CORS policy blocked`

```typescript
// Update backend/src/index.ts
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(','),
  credentials: true
}));
```

#### 5. Crawler Not Working

**Error**: Puppeteer timeout

```bash
# Install Chromium dependencies (Ubuntu)
sudo apt install -y chromium-browser
```

#### 6. Newsletter Not Sending

**Error**: `Resend API error`

- Verify `RESEND_API_KEY` is correct
- Check email domain is verified in Resend
- Ensure `RESEND_FROM_EMAIL` uses verified domain

### Debug Mode

Enable debug logging:

```env
# .env
DEBUG=true
LOG_LEVEL=debug
```

View detailed logs in console.

---

## Performance Optimization

### 1. Enable Caching

```typescript
// Redis caching for articles
const cachedArticles = await redis.get('articles:latest');
if (cachedArticles) {
  return JSON.parse(cachedArticles);
}

const articles = await Article.find().limit(20);
await redis.set('articles:latest', JSON.stringify(articles), 'EX', 3600);
```

### 2. Database Indexing

```javascript
// Ensure indexes are created
db.articles.createIndex({ publishedAt: -1 });
db.articles.createIndex({ topics: 1 });
db.articles.createIndex({ title: "text", summary: "text" });
```

### 3. Image Optimization

```typescript
// Use Next.js Image component
import Image from 'next/image';

<Image
  src={article.imageUrl}
  width={600}
  height={400}
  alt={article.title}
  loading="lazy"
/>
```

### 4. Bundle Size Reduction

```bash
# Analyze bundle
npm run analyze

# Remove unused dependencies
npx depcheck
```

---

## Rollback Procedures

### Vercel Rollback

1. Go to Vercel dashboard
2. Navigate to "Deployments"
3. Find previous working deployment
4. Click "Promote to Production"

### Docker Rollback

```bash
# List images
docker images

# Rollback to previous version
docker-compose down
docker-compose up -d ai-content-curator:previous-tag
```

### Manual Rollback

```bash
# Git rollback
git log
git revert <commit-hash>
git push

# PM2 restart
pm2 restart all
```

---

## Security Checklist

Before going to production:

- [ ] All secrets in environment variables (not code)
- [ ] HTTPS enabled (SSL certificate)
- [ ] CORS configured with specific origins
- [ ] Rate limiting enabled
- [ ] Database access restricted to specific IPs
- [ ] Strong JWT secrets (64+ characters)
- [ ] Password hashing with bcrypt
- [ ] Input validation on all endpoints
- [ ] Security headers (Helmet.js)
- [ ] Dependencies up to date (`npm audit`)
- [ ] Error messages don't leak sensitive info
- [ ] Logs don't contain passwords/tokens

---

## Resources

- [Vercel Documentation](https://vercel.com/docs)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Docker Documentation](https://docs.docker.com/)
- [PM2 Documentation](https://pm2.keymetrics.io/docs/)
- [Next.js Deployment](https://nextjs.org/docs/deployment)

---

## Support

For deployment issues:
- Check [GitHub Issues](https://github.com/SynthoraAI-AI-News-Content-Curator/AI-Content-Curator-Monorepo/issues)
- Review [Architecture Documentation](./ARCHITECTURE.md)
- Consult [API Documentation](./API.md)

---

**Last Updated**: 2025-11-13
