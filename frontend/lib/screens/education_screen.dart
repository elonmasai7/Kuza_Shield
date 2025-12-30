import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/education_provider.dart';
import '../providers/auth_provider.dart';
import '../models/lesson_model.dart';
import '../widgets/quiz_widget.dart';

class EducationScreen extends StatefulWidget {
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  void initState() {
    super.initState();
    final userSector = Provider.of<AuthProvider>(context, listen: false).user.sector ?? 'general';
    Provider.of<EducationProvider>(context, listen: false).fetchLessons(userSector);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cyber Education')),
      body: Consumer<EducationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.lessons.isEmpty) {
            return Center(child: Text('No lessons available. Please check your connection.'));
          }
          return ListView.builder(
            itemCount: provider.lessons.length,
            itemBuilder: (context, index) {
              final lesson = provider.lessons[index];
              double progress = provider.getProgress(lesson.id);
              return ExpansionTile(
                title: Text(lesson.title),
                subtitle: Text('Progress: $progress%'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(lesson.content),
                  ),
                  if (lesson.quizQuestions.isNotEmpty)
                    QuizWidget(
                      questions: lesson.quizQuestions,
                      onComplete: (score) => provider.saveProgress(lesson.id, score),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}