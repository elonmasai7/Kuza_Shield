import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Function(double) onComplete;

  const QuizWidget({super.key, required this.questions, required this.onComplete});

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedOption;

  void _answer() {
    if (_selectedOption == widget.questions[_currentQuestion]['answer']) {
      _score++;
    }
    if (_currentQuestion < widget.questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
      });
    } else {
      double finalScore = (_score / widget.questions.length) * 100;
      widget.onComplete(finalScore);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz Complete'),
          content: Text('Score: $finalScore%'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_currentQuestion];
    return Column(
      children: [
        Text(q['question'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ...(q['options'] as List<String>).asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: _selectedOption,
              onChanged: (val) => setState(() => _selectedOption = val),
            )),
        ElevatedButton(onPressed: _selectedOption != null ? _answer : null, child: Text('Submit Answer')),
      ],
    );
  }
}