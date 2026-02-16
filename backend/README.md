# Haven Backend API

Flask-based REST API for the Haven domestic violence prevention app.

## Quick Start

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Set Environment Variables
Copy `.env.example` to `.env` and update as needed (already pre-configured for development):
```bash
cp .env.example .env
```

### 3. Run the App
```bash
python app.py
```

The API will be available at `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` — Register new user
- `POST /api/auth/login` — Login user
- `POST /api/auth/logout` — Logout (client-side token removal)

### Alerts
- `GET /api/alerts` — Get all alerts for user
- `POST /api/alerts` — Create new alert (panic button or manual)
- `GET /api/alerts/<id>` — Get specific alert
- `PUT /api/alerts/<id>/acknowledge` — Mark alert as acknowledged

### Signals
- `GET /api/signals` — Get all detected signals
- `POST /api/signals` — Create new signal (on-device detection)

### User Profile
- `GET /api/user` — Get current user profile
- `PUT /api/user` — Update user profile
- `GET /api/user/consent` — Get consent settings
- `PUT /api/user/consent` — Update consent settings

### Health
- `GET /api/health` — Health check endpoint

## Authentication

All protected endpoints require JWT Bearer token in `Authorization` header:
```
Authorization: Bearer <access_token>
```

Tokens are obtained from `/api/auth/login` or `/api/auth/register` endpoints.

## Database

### Configured Databases

**Development/Testing**: SQLite (file-based)
```
database_url=sqlite:///havenapp.db
```

**Production**: PostgreSQL (recommended)
```
database_url=postgresql://user:password@localhost:5432/havenapp
```

### Models

- **User** — User account (email, password, profile)
- **Signal** — Detected safety signal (communication, movement, device, self-report)
- **Alert** — Generated alert (risk level, type, signals)
- **ConsentRecord** — User privacy preferences
- **EmergencyContact** — Trusted contacts and safety advocates
- **AuditLog** — Activity logging for compliance

## Configuration

See `config.py` for environment-specific settings:

- `development` — Debug mode enabled, SQLite database, verbose logging
- `testing` — In-memory database, test JWT tokens, no persistence
- `production` — Debug disabled, PostgreSQL, secure defaults

## API Response Format

All endpoints return JSON:

### Success Response (2xx)
```json
{
  "id": "...",
  "field": "value"
}
```

### Error Response (4xx/5xx)
```json
{
  "error": "Error message describing the problem"
}
```

## Testing

### Test User Registration
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123",
    "name": "Test User"
  }'
```

### Test User Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123"
  }'
```

### Create Panic Alert
```bash
curl -X POST http://localhost:5000/api/alerts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_token>" \
  -d '{
    "type": "panic",
    "riskLevel": 0.95,
    "signals": ["manual_activation"]
  }'
```

## Deployment

### With Gunicorn (Production)
```bash
gunicorn -w 4 -b 0.0.0.0:5000 app:create_app()
```

### Docker
```bash
docker build -t haven-backend .
docker run -p 5000:5000 haven-backend
```

## Security Considerations

1. **Never commit `.env` file** — Use `.env.example` as template
2. **Change secret keys in production** — Generate strong random keys
3. **Use HTTPS in production** — Enable SSL/TLS
4. **Database credentials** — Use secure environment variables
5. **Rate limiting** — Enabled by default (uses Redis in production)
6. **CORS** — Configure allowed origins in production
7. **JWT tokens** — 1 hour access token, 30 day refresh token

## Troubleshooting

### Port already in use
```bash
lsof -i :5000  # Find process using port 5000
kill -9 <PID>  # Kill the process
```

### Database locked (SQLite)
SQLite has limited concurrent access. For production, migrate to PostgreSQL.

### JWT token expired
Request a new token by logging in again.

## Environment Variables Reference

```
FLASK_ENV              # development, testing, production
FLASK_DEBUG            # True/False
DATABASE_URL           # Database connection string
SECRET_KEY             # Flask session secret (change in prod!)
JWT_SECRET_KEY         # JWT signing secret (change in prod!)
ENCRYPTION_KEY         # 32-char encryption key for sensitive data
REDIS_URL              # Redis URL for rate limiting (optional)
LOG_LEVEL              # DEBUG, INFO, WARNING, ERROR, CRITICAL
```

See `.env.example` for more details.

---

For frontend integration, see the mobile app documentation in `../mobile/`.
