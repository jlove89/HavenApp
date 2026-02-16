from datetime import datetime, timedelta
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.String(36), primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    name = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)

    # Relationships
    consent_records = db.relationship('ConsentRecord', backref='user', lazy=True, cascade='all, delete-orphan')
    signals = db.relationship('Signal', backref='user', lazy=True, cascade='all, delete-orphan')
    alerts = db.relationship('Alert', backref='user', lazy=True, cascade='all, delete-orphan')
    contacts = db.relationship('EmergencyContact', backref='user', lazy=True, cascade='all, delete-orphan')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            'id': self.id,
            'email': self.email,
            'name': self.name,
            'created_at': self.created_at.isoformat(),
            'is_active': self.is_active,
        }


class ConsentRecord(db.Model):
    __tablename__ = 'consent_records'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    passive_detection = db.Column(db.Boolean, default=True)
    location_tracking = db.Column(db.Boolean, default=False)
    journaling = db.Column(db.Boolean, default=True)
    emergency_sharing = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'passive_detection': self.passive_detection,
            'location_tracking': self.location_tracking,
            'journaling': self.journaling,
            'emergency_sharing': self.emergency_sharing,
            'updated_at': self.updated_at.isoformat(),
        }


class Signal(db.Model):
    __tablename__ = 'signals'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    category = db.Column(db.String(50), nullable=False)  # communication, movement, device, self_report
    signal_type = db.Column(db.String(100), nullable=False)
    confidence = db.Column(db.Float, default=0.0)  # 0.0 to 1.0
    metadata = db.Column(db.JSON)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'category': self.category,
            'type': self.signal_type,
            'confidence': self.confidence,
            'metadata': self.metadata,
            'timestamp': self.created_at.isoformat(),
        }


class Alert(db.Model):
    __tablename__ = 'alerts'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    risk_level = db.Column(db.Float, default=0.0)  # 0.0 to 1.0
    alert_type = db.Column(db.String(50), default='passive')  # passive, manual, panic
    signals = db.Column(db.JSON)  # List of signal IDs contributing to alert
    acknowledged = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'riskLevel': self.risk_level,
            'type': self.alert_type,
            'signals': self.signals or [],
            'acknowledged': self.acknowledged,
            'timestamp': self.created_at.isoformat(),
        }


class EmergencyContact(db.Model):
    __tablename__ = 'emergency_contacts'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(20))
    email = db.Column(db.String(255))
    relationship = db.Column(db.String(100))
    is_advocate = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'phone': self.phone,
            'email': self.email,
            'relationship': self.relationship,
            'is_advocate': self.is_advocate,
        }


class AuditLog(db.Model):
    __tablename__ = 'audit_logs'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    action = db.Column(db.String(255), nullable=False)
    resource_type = db.Column(db.String(100))
    resource_id = db.Column(db.String(36))
    details = db.Column(db.JSON)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow, index=True)

    def to_dict(self):
        return {
            'id': self.id,
            'action': self.action,
            'resource_type': self.resource_type,
            'resource_id': self.resource_id,
            'timestamp': self.timestamp.isoformat(),
        }
