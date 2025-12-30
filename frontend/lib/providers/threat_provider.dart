class Threat {
  final bool isPhishing;
  final double confidence;

  Threat({required this.isPhishing, required this.confidence});

  factory Threat.fromJson(Map<String, dynamic> json) {
    return Threat(
      isPhishing: json['is_phishing'] ?? json['is_threat'] ?? false,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}