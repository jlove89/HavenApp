class User {
  final String id;
  final String email;
  final String? name;
  final String timezone;
  final ConsentScope consentScope;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    this.name,
    this.timezone = 'UTC',
    required this.consentScope,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      timezone: json['timezone'] ?? 'UTC',
      consentScope: ConsentScope.fromJson(json['consent_scope'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'timezone': timezone,
    'consent_scope': consentScope.toJson(),
    'created_at': createdAt.toIso8601String(),
  };
}

class ConsentScope {
  final bool passiveDetection;
  final bool location;
  final bool journaling;
  final bool emergencySharing;

  ConsentScope({
    required this.passiveDetection,
    required this.location,
    required this.journaling,
    required this.emergencySharing,
  });

  factory ConsentScope.fromJson(Map<String, dynamic> json) {
    return ConsentScope(
      passiveDetection: json['passive_detection'] ?? false,
      location: json['location'] ?? false,
      journaling: json['journaling'] ?? false,
      emergencySharing: json['emergency_sharing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'passive_detection': passiveDetection,
    'location': location,
    'journaling': journaling,
    'emergency_sharing': emergencySharing,
  };
}
