import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/screens/components/finished_todos_widget.dart';

class TodoFinishedScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  const TodoFinishedScreen({super.key, required this.todoRepository});

  @override
  State<TodoFinishedScreen> createState() => _TodoFinishedScreenState();
}

class _TodoFinishedScreenState extends State<TodoFinishedScreen> {
  void deleteToDo(String docID) {
    widget.todoRepository.deleteToDo(docID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fertige ToDo's",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: FinishedTodosWidget(todoRepository: widget.todoRepository),
          ),
        ),
      ),
    );
  }
}
