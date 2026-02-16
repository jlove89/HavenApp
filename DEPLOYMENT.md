# HavenApp - Deployment Guide

Complete instructions for deploying HavenApp across all platforms (Backend API, Web, iOS, Android).

## Table of Contents
1. [Backend API Deployment](#backend-api-deployment)
2. [Mobile Web Deployment](#mobile-web-deployment)
3. [iOS Deployment](#ios-deployment)
4. [Android Deployment](#android-deployment)
5. [Environment Configuration](#environment-configuration)
6. [Monitoring & Logs](#monitoring--logs)

---

## Backend API Deployment

### Option 1: Heroku (Recommended for simplicity)

#### Prerequisites
- Heroku account (free tier available, credit card required)
- Heroku CLI installed (`brew install heroku` on macOS)

#### Steps

1. **Login to Heroku**
```bash
heroku login
```

2. **Create Heroku App**
```bash
cd backend
heroku create havenapp-api  # Replace with your app name
```

3. **Add PostgreSQL Database**
```bash
heroku addons:create heroku-postgresql:hobby-dev
```

4. **Add Redis for Rate Limiting**
```bash
heroku addons:create heroku-redis:premium-0
```

5. **Set Environment Variables**
```bash
# Generate secure keys
python -c "import secrets; print(secrets.token_urlsafe(32))"
python -c "import secrets; print(secrets.token_urlsafe(32))"
python -c "import secrets; print(secrets.token_bytes(32).hex())"

# Set them on Heroku
heroku config:set SECRET_KEY=<generated-secret-key>
heroku config:set JWT_SECRET_KEY=<generated-jwt-secret>
heroku config:set ENCRYPTION_KEY=<generated-encryption-key>
```

6. **Deploy**
```bash
git push heroku main
```

7. **Initialize Database**
```bash
heroku run python -c "from app import app, db; app.app_context().push(); db.create_all()"
```

8. **View Logs**
```bash
heroku logs --tail
```

#### Access API
```
https://havenapp-api.herokuapp.com/api
```

---

### Option 2: Railway (Faster deployment, better free tier)

#### Prerequisites
- Railway account (https://railway.app)
- Railway CLI installed

#### Steps

1. **Install Railway CLI**
```bash
npm install -g @railway/cli
# or use: brew install railway
```

2. **Login**
```bash
railway login
```

3. **Initialize Project**
```bash
cd backend
railway init
```

4. **Create Database Service**
```bash
railway add --image postgres
```

5. **Add Redis Service**
```bash
railway add --image redis
```

6. **Link YOUR_DATABASE_URL**
```bash
railway variables
# Copy the DATABASE_URL from PostgreSQL service
```

7. **Deploy**
```bash
railway up
```

#### Access API
```
Get URL from Railway dashboard
```

---

### Option 3: Docker + AWS ECS

#### Prerequisites
- AWS account
- Docker installed
- AWS CLI configured

#### Steps

1. **Build Docker Image**
```bash
cd backend
docker build -t havenapp-api .
```

2. **Push to ECR (AWS Container Registry)**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com

docker tag havenapp-api <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/havenapp-api:latest

docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/havenapp-api:latest
```

3. **Create ECS Task & Service**
- Use AWS Console or CloudFormation
- Link RDS PostgreSQL database
- ElastiCache for Redis

---

### Local Production Testing

Before deploying to cloud:

```bash
cd backend

# Install production dependencies
pip install -r requirements.txt

# Create PostgreSQL DB locally
# Update .env.production with your local DB URL
# DATABASE_URL=postgresql://user:password@localhost/havenapp

# Set environment
export FLASK_ENV=production
export DATABASE_URL=postgresql://user:password@localhost/havenapp

# Initialize database
python -c "from app import app, db; app.app_context().push(); db.create_all()"

# Run with gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 --timeout 120 app:app
```

Then access: http://localhost:5000/api

---

## Mobile Web Deployment

The Flutter web version can be deployed to any static hosting or with a server.

### Option 1: Firebase Hosting (Recommended)

#### Prerequisites
- Firebase project (https://console.firebase.google.com)
- Firebase CLI: `npm install -g firebase-tools`

#### Steps

1. **Login to Firebase**
```bash
firebase login
```

2. **Initialize Firebase**
```bash
cd mobile
firebase init hosting
# Choose your project
# Public directory: build/web
```

3. **Build Web Release**
```bash
flutter build web --release
```

4. **Deploy**
```bash
firebase deploy
```

#### Access Web App
```
https://your-project-id.web.app
```

---

### Option 2: Vercel (Great CI/CD integration)

#### Prerequisites
- Vercel account (https://vercel.com)
- Vercel CLI: `npm install -g vercel`

#### Steps

1. **Login**
```bash
vercel login
```

2. **Build for Web**
```bash
cd mobile
flutter build web --release
```

3. **Deploy Build**
```bash
vercel build/web
```

#### Access Web App
```
https://your-project.vercel.app
```

---

### Option 3: GitHub Pages

1. **Build for Web**
```bash
cd mobile
flutter build web --release
```

2. **Commit build folder**
```bash
git add build/web
git commit -m "Build: Flutter web release"
git push
```

3. **Enable GitHub Pages**
- Repository Settings → Pages
- Source: main branch, /build/web folder

#### Access Web App
```
https://your-username.github.io/HavenApp
```

---

## iOS Deployment

### Prerequisites
- macOS with Xcode installed
- Apple Developer account ($99/year)
- iPhone or iOS simulator

### TestFlight Distribution (Easiest)

1. **Update Version**
```bash
cd mobile

# Edit pubspec.yaml
# Change: version: 0.1.0+1
# To: version: 1.0.0+1
```

2. **Configure iOS Project**
```bash
cd ios

# Edit Runner/Info.plist
# Add required permissions and metadata
```

3. **Build for iOS**
```bash
cd ..
flutter build ios --release
```

4. **Create App Signing**
```bash
open ios/Runner.xcworkspace
# In Xcode:
# - Select Runner under Project
# - Team: Signing & Capabilities
# - Select your Apple Developer Team
```

5. **Archive App**
```bash
flutter build ipa --release
```

6. **Upload to Application Loader**
```bash
# In Xcode: Window → Devices & Simulators
# Or use Transporter app from App Store
# Upload the .ipa file
```

7. **Invite Beta Testers in App Store Connect**
- Go to your app in App Store Connect
- TestFlight tab → Builds → Select your build
- Add internal/external testers

### App Store Release

When ready for public release:
1. Prepare app store listing (screenshots, description, keywords)
2. Submit for review in App Store Connect
3. Process typically takes 24-48 hours

---

## Android Deployment

### Prerequisites
- Android Studio installed
- Google Play Developer account ($25 one-time)
- Keystore file for signing

### Generate Signing Key

```bash
keytool -genkey -v -keystore ~/havenapp-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias havenapp
```

### Build Release APK

1. **Configure Build**
```bash
cd mobile

# Create/Edit android/key.properties
echo "storeFile=/path/to/havenapp-key.jks" > android/key.properties
echo "storePassword=your-password" >> android/key.properties
echo "keyPassword=your-password" >> android/key.properties
echo "keyAlias=havenapp" >> android/key.properties
```

2. **Update Build Config**
```bash
# Edit android/app/build.gradle
# Add signing config and build types
```

3. **Build App Bundle (for Play Store)**
```bash
flutter build appbundle --release
```

4. **Or Build APK (direct installation)**
```bash
flutter build apk --release
```

### Upload to Google Play Store

1. **Create App Listing**
   - Go to Google Play Console
   - Create new app
   - Fill in app details (title, description, category, ratings)

2. **Upload Build**
   - Production track → Create release
   - Upload .aab file
   - Add release notes

3. **Add Store Listing**
   - Screenshots (min 2, max 8 per device type)
   - Feature graphic (1024x500 px)
   - App icon (512x512 px)
   - Description, short description

4. **Content Rating**
   - Complete questionnaire
   - Get content rating

5. **Pricing & Distribution**
   - Set price (free or paid)
   - Select countries

6. **Submit for Review**
   - Review takes 2-4 hours typically
   - Automated + manual review

---

## Environment Configuration

### Production API Configurations

Update these URLs based on your deployment:

**Backend API:**
- Heroku: `https://havenapp-api.herokuapp.com/api`
- Railway: Get from dashboard
- AWS: Your ECS ALB URL

**Update mobile app:**

```bash
# Flutter - Update environment_config.dart
# Change production API endpoint to your deployed backend

# Run with production config:
flutter run --dart-define=APP_ENVIRONMENT=production
flutter build web --dart-define=APP_ENVIRONMENT=production
flutter build ios --dart-define=APP_ENVIRONMENT=production
flutter build apk --dart-define=APP_ENVIRONMENT=production
```

### Security Checklist

- [ ] Generate new SECRET_KEY and JWT_SECRET_KEY
- [ ] Generate new ENCRYPTION_KEY
- [ ] Enable HTTPS/SSL certificates
- [ ] Set secure session cookies
- [ ] Enable CORS only for your domains
- [ ] Set up database backups
- [ ] Enable API rate limiting
- [ ] Set up error logging (Sentry, Rollbar, etc.)
- [ ] Set up health check monitoring
- [ ] Enable HSTS headers
- [ ] Rotate security keys periodically

---

## Monitoring & Logs

### Backend Logs

**Heroku:**
```bash
heroku logs --tail
heroku logs -n 100  # Last 100 lines
```

**Railway:**
Dashboard → Logs tab

**AWS:**
CloudWatch → Log Groups → ECS task logs

### Error Tracking

Recommended services:
- **Sentry** (Free tier available): Real-time error tracking
- **Datadog**: Comprehensive monitoring
- **New Relic**: APM and monitoring

### Health Checks

Backend provides health endpoint:
```bash
curl https://your-api-domain/api/health
```

Response:
```json
{
  "status": "ok",
  "timestamp": "2024-02-15T10:30:00Z",
  "database": "connected"
}
```

---

## Deployment Checklist

- [ ] Backend API deployed and accessible
- [ ] Database initialized and running
- [ ] Environment variables set correctly
- [ ] CORS configured for your domains
- [ ] SSL/HTTPS enabled
- [ ] Database backups configured
- [ ] Monitoring and logging set up
- [ ] Error tracking enabled
- [ ] Mobile app API endpoint updated
- [ ] Mobile web app deployed
- [ ] iOS app in TestFlight or App Store
- [ ] Android app in Google Play Store
- [ ] Custom domain configured (optional)

---

## Troubleshooting

### Backend Won't Start
```bash
# Check environment variables
heroku config  # Heroku

# Check logs
heroku logs --tail

# Verify database connection
heroku run "python -c 'from app import db; print(db.engine.url)'"
```

### Mobile App Can't Connect to API
- Check API endpoint URL in environment_config.dart
- Ensure backend has CORS enabled for your domain
- Check firewall/security group rules
- Verify SSL certificate is valid

### Database Issues
```bash
# Reset database (⚠️ deletes all data)
heroku pg:reset DATABASE_URL --confirm your-app-name

# Check database size
heroku pg:info
```

---

## Support

For issues or questions:
1. Check backend logs: `heroku logs --tail`
2. Check mobile app debug logs
3. Review this guide's troubleshooting section
4. Open an issue on GitHub

