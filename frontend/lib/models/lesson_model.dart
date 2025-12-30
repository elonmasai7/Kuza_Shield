import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 1)
class Lesson extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late String sector;

  @HiveField(4)
  late List<Map<String, dynamic>> quizQuestions;

  Lesson({required this.id, required this.title, required this.content, required this.sector, this.quizQuestions = const []});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      sector: json['sector'],
      quizQuestions: (json['quiz_questions'] as List? ?? []).cast<Map<String, dynamic>>(),
    );
  }
}