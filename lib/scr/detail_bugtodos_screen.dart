import 'package:flutter/material.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';

class DetailBugTodoScreen extends StatelessWidget {
  final BugTodoFirebaseModel bugTodo;

  const DetailBugTodoScreen({Key? key, required this.bugTodo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(bugTodo.title),
            SizedBox(height: 16),
            Text(
              'Contents:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(bugTodo.contents),
            SizedBox(height: 16),
            Text(
              'Is Done:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(bugTodo.isDone ? 'Yes' : 'No'),
            SizedBox(height: 16),
            Text(
              'Level:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_getLevelString(bugTodo.level)),
          ],
        ),
      ),
    );
  }

  String _getLevelString(int level) {
    switch (level) {
      case 1:
        return 'High';
      case 2:
        return 'Middle';
      default:
        return 'Low';
    }
  }
}
