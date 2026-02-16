"""HavenApp Backend - Configuration"""
import os
from datetime import timedelta

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'dev-key-change-in-prod')
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///havenapp.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY', 'jwt-dev-key')
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=30)
    ENCRYPTION_KEY = os.environ.get('ENCRYPTION_KEY', None)
    RATELIMIT_ENABLED = True
    RATELIMIT_STORAGE_URL = os.environ.get('REDIS_URL', 'memory://')
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    SIGNAL_RETENTION_DAYS = 30
    SHARE_EXPIRY_DAYS = 7

class DevelopmentConfig(Config):
    DEBUG = True
    TESTING = False

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=5)

class ProductionConfig(Config):
    DEBUG = False

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
