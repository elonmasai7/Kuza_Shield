class Threat {
  final bool isPhishing;
  final double confidence;
  final DateTime timestamp;  // New

  Threat({required this.isPhishing, required this.confidence, required this.timestamp});

  factory Threat.fromJson(Map<String, dynamic> json) {
    return Threat(
      isPhishing: json['is_phishing'] ?? json['is_threat'] ?? false,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.now(),  // Add timestamp on creation
    );
  }

  @override
  String toString() => timestamp.toIso8601String();
}