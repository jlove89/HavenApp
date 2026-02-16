import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity
from datetime import datetime

from config import config
from models import db, User, Signal, Alert, ConsentRecord, EmergencyContact, AuditLog
from auth import authenticate_user, create_tokens, register_user, generate_id
from schemas import (
    user_schema, login_schema, register_schema, signal_schema, signals_schema,
    alert_schema, alerts_schema, panic_alert_schema
)


def create_app(config_name='development'):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    db.init_app(app)
    CORS(app)
    jwt = JWTManager(app)
    
    with app.app_context():
        db.create_all()
    
    # Helper function to get current user
    def get_current_user():
        try:
            user_id = get_jwt_identity()
            user = User.query.get(user_id)
            if user and user.is_active:
                return user
        except:
            pass
        return None
    
    # Auth endpoints
    @app.route('/api/auth/register', methods=['POST'])
    def register():
        data = request.get_json()
        
        try:
            errors = register_schema.validate(data)
            if errors:
                return jsonify({'error': errors}), 400
        except Exception as e:
            return jsonify({'error': str(e)}), 400
        
        user, error = register_user(data['email'], data['password'], data.get('name'))
        if error:
            return jsonify({'error': error}), 400
        
        access_token, refresh_token = create_tokens(user.id)
        app.logger.info(f'User registered: {user.email}')
        
        return jsonify({
            'access_token': access_token,
            'refresh_token': refresh_token,
            'user': user.to_dict(),
        }), 201
    
    @app.route('/api/auth/login', methods=['POST'])
    def login():
        data = request.get_json()
        
        try:
            errors = login_schema.validate(data)
            if errors:
                return jsonify({'error': errors}), 400
        except Exception as e:
            return jsonify({'error': str(e)}), 400
        
        user = authenticate_user(data['email'], data['password'])
        if not user:
            return jsonify({'error': 'Invalid credentials'}), 401
        
        access_token, refresh_token = create_tokens(user.id)
        app.logger.info(f'User logged in: {user.email}')
        
        return jsonify({
            'access_token': access_token,
            'refresh_token': refresh_token,
            'user': user.to_dict(),
        }), 200
    
    @app.route('/api/auth/logout', methods=['POST'])
    def logout():
        # Token is invalidated on client side (removed from secure storage)
        return jsonify({'message': 'Logged out successfully'}), 200
    
    # Alert endpoints
    @app.route('/api/alerts', methods=['GET'])
    @jwt_required()
    def get_alerts():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        alerts = Alert.query.filter_by(user_id=user.id).order_by(Alert.created_at.desc()).all()
        return jsonify(alerts_schema.dump(alerts)), 200
    
    @app.route('/api/alerts', methods=['POST'])
    @jwt_required()
    def create_alert():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        data = request.get_json()
        
        try:
            if data.get('type') == 'panic':
                errors = panic_alert_schema.validate(data)
            else:
                errors = alert_schema.validate(data)
            if errors:
                return jsonify({'error': errors}), 400
        except Exception as e:
            return jsonify({'error': str(e)}), 400
        
        alert = Alert(
            id=generate_id(),
            user_id=user.id,
            risk_level=data.get('riskLevel', 0.0),
            alert_type=data.get('type', 'manual'),
            signals=data.get('signals', []),
        )
        
        db.session.add(alert)
        db.session.commit()
        
        # Log the action
        audit = AuditLog(
            id=generate_id(),
            user_id=user.id,
            action=f'created_alert',
            resource_type='alert',
            resource_id=alert.id,
            details={'type': alert.alert_type, 'risk_level': alert.risk_level},
        )
        db.session.add(audit)
        db.session.commit()
        
        app.logger.info(f'Alert created for user {user.email}: {alert.alert_type}')
        
        return jsonify(alert.to_dict()), 201
    
    @app.route('/api/alerts/<alert_id>', methods=['GET'])
    @jwt_required()
    def get_alert(alert_id):
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        alert = Alert.query.filter_by(id=alert_id, user_id=user.id).first()
        if not alert:
            return jsonify({'error': 'Alert not found'}), 404
        
        return jsonify(alert.to_dict()), 200
    
    @app.route('/api/alerts/<alert_id>/acknowledge', methods=['PUT'])
    @jwt_required()
    def acknowledge_alert(alert_id):
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        alert = Alert.query.filter_by(id=alert_id, user_id=user.id).first()
        if not alert:
            return jsonify({'error': 'Alert not found'}), 404
        
        alert.acknowledged = True
        alert.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify(alert.to_dict()), 200
    
    # Signal endpoints
    @app.route('/api/signals', methods=['POST'])
    @jwt_required()
    def create_signal():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        data = request.get_json()
        
        try:
            errors = signal_schema.validate(data)
            if errors:
                return jsonify({'error': errors}), 400
        except Exception as e:
            return jsonify({'error': str(e)}), 400
        
        signal = Signal(
            id=generate_id(),
            user_id=user.id,
            category=data.get('category'),
            signal_type=data.get('type'),
            confidence=data.get('confidence', 0.0),
            metadata=data.get('metadata'),
        )
        
        db.session.add(signal)
        db.session.commit()
        
        app.logger.info(f'Signal created for user {user.email}: {signal.signal_type}')
        
        return jsonify(signal.to_dict()), 201
    
    @app.route('/api/signals', methods=['GET'])
    @jwt_required()
    def get_signals():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        signals = Signal.query.filter_by(user_id=user.id).order_by(Signal.created_at.desc()).all()
        return jsonify(signals_schema.dump(signals)), 200
    
    # User consent endpoints
    @app.route('/api/user/consent', methods=['GET'])
    @jwt_required()
    def get_consent():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        consent = ConsentRecord.query.filter_by(user_id=user.id).first()
        if not consent:
            # Create default consent record
            consent = ConsentRecord(
                id=generate_id(),
                user_id=user.id,
            )
            db.session.add(consent)
            db.session.commit()
        
        return jsonify(consent.to_dict()), 200
    
    @app.route('/api/user/consent', methods=['PUT'])
    @jwt_required()
    def update_consent():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        data = request.get_json()
        
        consent = ConsentRecord.query.filter_by(user_id=user.id).first()
        if not consent:
            consent = ConsentRecord(
                id=generate_id(),
                user_id=user.id,
            )
            db.session.add(consent)
        
        if 'passive_detection' in data:
            consent.passive_detection = data['passive_detection']
        if 'location_tracking' in data:
            consent.location_tracking = data['location_tracking']
        if 'journaling' in data:
            consent.journaling = data['journaling']
        if 'emergency_sharing' in data:
            consent.emergency_sharing = data['emergency_sharing']
        
        consent.updated_at = datetime.utcnow()
        db.session.commit()
        
        app.logger.info(f'Consent updated for user {user.email}')
        
        return jsonify(consent.to_dict()), 200
    
    # User profile endpoints
    @app.route('/api/user', methods=['GET'])
    @jwt_required()
    def get_user():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        return jsonify(user.to_dict()), 200
    
    @app.route('/api/user', methods=['PUT'])
    @jwt_required()
    def update_user():
        user = get_current_user()
        if not user:
            return jsonify({'error': 'Unauthorized'}), 401
        
        data = request.get_json()
        
        if 'name' in data:
            user.name = data['name']
        
        user.updated_at = datetime.utcnow()
        db.session.commit()
        
        app.logger.info(f'User profile updated: {user.email}')
        
        return jsonify(user.to_dict()), 200
    
    # Health check
    @app.route('/api/health', methods=['GET'])
    def health_check():
        return jsonify({'status': 'healthy', 'timestamp': datetime.utcnow().isoformat()}), 200
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        app.logger.error(f'Internal server error: {str(error)}')
        return jsonify({'error': 'Internal server error'}), 500
    
    return app


if __name__ == '__main__':
    app = create_app(os.getenv('FLASK_ENV', 'development'))
    app.run(debug=True, host='0.0.0.0', port=5000)
