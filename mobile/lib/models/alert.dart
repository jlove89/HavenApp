import 'package:flutter/material.dart';

class Alert {
  final String id;
  final String userId;
  final String riskLevel;
  final DateTime triggeredAt;
  final List<String> triggerSignals;
  final double combinedScore;
  final String actionTaken;
  final String? feedback;

  Alert({
    required this.id,
    required this.userId,
    required this.riskLevel,
    required this.triggeredAt,
    required this.triggerSignals,
    required this.combinedScore,
    this.actionTaken = 'pending',
    this.feedback,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      riskLevel: json['risk_level'] ?? 'green',
      triggeredAt: DateTime.parse(json['triggered_at'] ?? DateTime.now().toIso8601String()),
      triggerSignals: List<String>.from(json['trigger_signals'] ?? []),
      combinedScore: (json['combined_score'] as num?)?.toDouble() ?? 0.0,
      actionTaken: json['action_taken'] ?? 'pending',
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'risk_level': riskLevel,
    'triggered_at': triggeredAt.toIso8601String(),
    'trigger_signals': triggerSignals,
    'combined_score': combinedScore,
    'action_taken': actionTaken,
    'feedback': feedback,
  };

  Color getRiskColor() {
    switch (riskLevel) {
      case 'green':
        return const Color(0xFF4CAF50);
      case 'yellow':
        return const Color(0xFFFFC107);
      case 'orange':
        return const Color(0xFFFF9800);
      case 'red':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String getRiskLabel() {
    switch (riskLevel) {
      case 'green':
        return 'Safe';
      case 'yellow':
        return 'Caution';
      case 'orange':
        return 'High Risk';
      case 'red':
        return 'Critical';
      default:
        return 'Unknown';
    }
  }
}
