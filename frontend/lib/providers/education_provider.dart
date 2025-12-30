import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/lesson_model.dart';
import '../services/api_service.dart';

class EducationProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];
  Map<String, double> _progress = {};
  bool _isLoading = false;

  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;

  Future<void> fetchLessons(String sector) async {
    _isLoading = true;
    notifyListeners();

    try {
      var box = await Hive.openBox('lessons');
      if (box.containsKey(sector)) {
        _lessons = (box.get(sector) as List).map((e) => e as Lesson).toList();
      } else {
        final response = await ApiService.getLessons(sector);
        _lessons = response.map((json) => Lesson.fromJson(json)).toList();
        box.put(sector, _lessons);
      }
    } catch (e) {
      // Handle error, e.g., fallback to offline
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveProgress(String lessonId, double score) {
    _progress[lessonId] = score;
    ApiService.saveProgress(lessonId, score);
    notifyListeners();
  }

  double getProgress(String lessonId) => _progress[lessonId] ?? 0.0;
}