# Quick Start Deployment - Heroku

Get HavenApp running on the cloud in under 10 minutes.

## Prerequisites

1. **Heroku Account** (https://signup.heroku.com)
   - Free tier available (with credit card)
   
2. **Heroku CLI** 
   ```bash
   # macOS
   brew install heroku
   
   # Windows
   choco install heroku-cli
   
   # Or download from https://devcenter.heroku.com/articles/heroku-cli
   ```

3. **Git** and **Python** installed locally

## Deploy in 5 Steps

### Step 1: Login to Heroku

```bash
heroku login
# Opens browser for authentication
```

### Step 2: Create App on Heroku

```bash
cd backend
heroku create havenapp-api-yourname
```

Replace `yourname` with something unique (Heroku app names must be globally unique).

**Save your app URL** - it will look like: `https://havenapp-api-yourname.herokuapp.com`

### Step 3: Add Database

```bash
heroku addons:create heroku-postgresql:hobby-dev
```

This automatically sets `DATABASE_URL` environment variable.

### Step 4: Set Secret Keys

Generate random keys:
```bash
# Generate three secure keys
python -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))"
python -c "import secrets; print('JWT_SECRET_KEY=' + secrets.token_urlsafe(32))"
python -c "import secrets; print('ENCRYPTION_KEY=' + secrets.token_bytes(32).hex())"
```

Set them on Heroku:
```bash
heroku config:set SECRET_KEY=<paste-first-key-here>
heroku config:set JWT_SECRET_KEY=<paste-second-key-here>
heroku config:set ENCRYPTION_KEY=<paste-third-key-here>
```

### Step 5: Deploy & Initialize

```bash
git push heroku main

# Initialize database
heroku run python
```

In the Python shell:
```python
from app import app, db
app.app_context().push()
db.create_all()
exit()
```

## Done! 🎉

Your backend is live at: `https://havenapp-api-yourname.herokuapp.com/api`

### Test It

```bash
# Health check (should return 200 OK)
curl https://havenapp-api-yourname.herokuapp.com/api/health

# Register a user
curl -X POST https://havenapp-api-yourname.herokuapp.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User"}'
```

## Next: Connect Mobile App

Update the mobile app to use your deployed backend:

**File:** `mobile/lib/config/environment_config.dart`

Change:
```dart
case Environment.production:
  return 'https://havenapp-api-yourname.herokuapp.com/api';
```

Then run:
```bash
cd mobile
flutter run --dart-define=APP_ENVIRONMENT=production
```

## View Logs

```bash
heroku logs --tail
```

## Scale Up (if needed)

Free tier: 1 dyno (restarts every 24h)
Paid tier: Professional dyno for always-on

```bash
# Check current dyno
heroku ps

# Scale to professional (costs $7/month)
heroku dyno:type Standard-1x
```

## Stop & Restart

```bash
# Pause app (free tier only)
heroku ps:scale web=0

# Resume
heroku ps:scale web=1

# Restart
heroku restart
```

## Troubleshooting

### Database Not Initialized
```bash
heroku run "python -c \"from app import app, db; app.app_context().push(); db.create_all()\""
```

### Can't Connect from Mobile
- Check API URL is correct
- Make sure backend is running: `heroku ps`
- Check logs: `heroku logs --tail`
- Add your domain to CORS if needed

### Lost Database Data
Free tier Heroku databases reset every 30 days - use paid tier for persistence.

## Next Steps

1. ✅ Backend deployed
2. 📱 Deploy mobile web: See DEPLOYMENT.md → "Mobile Web Deployment"
3. 🍎 Deploy iOS: See DEPLOYMENT.md → "iOS Deployment"
4. 🤖 Deploy Android: See DEPLOYMENT.md → "Android Deployment"

---

For more options and advanced deployment, see [DEPLOYMENT.md](DEPLOYMENT.md)
