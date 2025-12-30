import 'package:flutter/foundation.dart';
import '../models/threat_model.dart';

class ThreatProvider extends ChangeNotifier {
  List<Threat> _threats = [];

  List<Threat> get threats => _threats;

  void addThreat(Map<String, dynamic> data) {
    _threats.add(Threat.fromJson(data));  // Timestamp added in model fromJson
    notifyListeners();
  }
}