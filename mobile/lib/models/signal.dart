enum SignalCategory {
  communication,
  movement,
  device,
  selfReport,
}

class Signal {
  final String id;
  final SignalCategory category;
  final String type; // e.g., "missed_calls", "location_change"
  final double confidence; // 0.0 - 1.0
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Signal({
    required this.id,
    required this.category,
    required this.type,
    required this.confidence,
    required this.timestamp,
    this.metadata,
  });

  factory Signal.fromJson(Map<String, dynamic> json) {
    return Signal(
      id: json['id'] as String? ?? '',
      category: SignalCategory.values.byName(json['category'] as String? ?? 'selfReport'),
      type: json['type'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category.name,
    'type': type,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}

class SignalScorer {
  // Heuristic signal scoring algorithm
  static double scoreSignals(List<Signal> signals) {
    if (signals.isEmpty) return 0.0;

    double score = 0.0;
    for (final signal in signals) {
      score += _scoreSignal(signal);
    }

    // Normalize by number of signals
    score = score / signals.length;
    
    // Cap at 1.0
    return score.clamp(0.0, 1.0);
  }

  static double _scoreSignal(Signal signal) {
    switch (signal.category) {
      case SignalCategory.communication:
        return _scoreCommunicationSignal(signal);
      case SignalCategory.movement:
        return _scoreMovementSignal(signal);
      case SignalCategory.device:
        return _scoreDeviceSignal(signal);
      case SignalCategory.selfReport:
        return signal.confidence; // Trust user input
    }
  }

  static double _scoreCommunicationSignal(Signal signal) {
    // Isolating communication patterns (blocked messages, missed calls)
    const baseScore = 0.3;
    return (baseScore + signal.confidence) / 2;
  }

  static double _scoreMovementSignal(Signal signal) {
    // Unusual location changes or restricted movement
    const baseScore = 0.4;
    return (baseScore + signal.confidence) / 2;
  }

  static double _scoreDeviceSignal(Signal signal) {
    // App usage patterns, battery drain, unfamiliar apps
    const baseScore = 0.25;
    return (baseScore + signal.confidence) / 2;
  }
}
