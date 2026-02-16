import uuid
from datetime import datetime, timedelta
from functools import wraps
from flask import request, jsonify, current_app
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity
from models import User, db


def generate_id():
    """Generate a UUID for database records"""
    return str(uuid.uuid4())


def get_current_user():
    """Get the currently authenticated user from JWT token"""
    try:
        from flask_jwt_extended import get_jwt_identity
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        if user and user.is_active:
            return user
    except:
        pass
    return None


def create_tokens(user_id):
    """Create access and refresh tokens"""
    access_token = create_access_token(
        identity=user_id,
        expires_delta=timedelta(hours=current_app.config.get('JWT_ACCESS_TOKEN_EXPIRES', 1))
    )
    refresh_token = create_refresh_token(
        identity=user_id,
        expires_delta=timedelta(days=current_app.config.get('JWT_REFRESH_TOKEN_EXPIRES', 30))
    )
    return access_token, refresh_token


def register_user(email, password, name=None):
    """Register a new user"""
    # Check if user already exists
    if User.query.filter_by(email=email).first():
        return None, 'User already exists'

    try:
        user = User(
            id=generate_id(),
            email=email,
            name=name,
        )
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        return user, None
    except Exception as e:
        db.session.rollback()
        return None, str(e)


def authenticate_user(email, password):
    """Authenticate user with email and password"""
    user = User.query.filter_by(email=email).first()
    if user and user.check_password(password):
        return user
    return None
