from marshmallow import Schema, fields, validate, ValidationError


class UserSchema(Schema):
    id = fields.Str(dump_only=True)
    email = fields.Email(required=True)
    name = fields.Str(allow_none=True)
    password = fields.Str(load_only=True, required=True, validate=validate.Length(min=8))
    created_at = fields.DateTime(dump_only=True)
    is_active = fields.Bool(dump_only=True)


class ConsentScopeSchema(Schema):
    passive_detection = fields.Bool(default=True)
    location_tracking = fields.Bool(default=False)
    journaling = fields.Bool(default=True)
    emergency_sharing = fields.Bool(default=False)


class SignalSchema(Schema):
    id = fields.Str(dump_only=True)
    category = fields.Str(required=True, validate=validate.OneOf([
        'communication', 'movement', 'device', 'self_report'
    ]))
    type = fields.Str(required=True)
    confidence = fields.Float(validate=validate.Range(min=0.0, max=1.0))
    metadata = fields.Dict(allow_none=True)
    timestamp = fields.DateTime(dump_only=True)


class AlertSchema(Schema):
    id = fields.Str(dump_only=True)
    riskLevel = fields.Float(validate=validate.Range(min=0.0, max=1.0))
    type = fields.Str(validate=validate.OneOf(['passive', 'manual', 'panic']))
    signals = fields.List(fields.Str())
    acknowledged = fields.Bool(default=False)
    timestamp = fields.DateTime(dump_only=True)


class EmergencyContactSchema(Schema):
    id = fields.Str(dump_only=True)
    name = fields.Str(required=True)
    phone = fields.Str(allow_none=True)
    email = fields.Email(allow_none=True)
    relationship = fields.Str(allow_none=True)
    is_advocate = fields.Bool(default=False)


class LoginSchema(Schema):
    email = fields.Email(required=True)
    password = fields.Str(required=True)


class RegisterSchema(Schema):
    email = fields.Email(required=True)
    password = fields.Str(required=True, validate=validate.Length(min=8))
    name = fields.Str(allow_none=True)


class PanicAlertSchema(Schema):
    type = fields.Str(default='panic')
    riskLevel = fields.Float(default=0.95)
    signals = fields.List(fields.Str(), default=['manual_activation'])


user_schema = UserSchema()
users_schema = UserSchema(many=True)
consent_schema = ConsentScopeSchema()
signal_schema = SignalSchema()
signals_schema = SignalSchema(many=True)
alert_schema = AlertSchema()
alerts_schema = AlertSchema(many=True)
emergency_contact_schema = EmergencyContactSchema()
emergency_contacts_schema = EmergencyContactSchema(many=True)
login_schema = LoginSchema()
register_schema = RegisterSchema()
panic_alert_schema = PanicAlertSchema()
