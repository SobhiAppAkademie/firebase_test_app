import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';

class TodoAddScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  const TodoAddScreen({super.key, required this.todoRepository});

  @override
  State<TodoAddScreen> createState() => _TodoAddScreenState();
}

class _TodoAddScreenState extends State<TodoAddScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  void addTodo() {
    final String title = titleController.text;
    final String text = textController.text;

    final todo = Todo(title: title, text: text, isDone: false, docID: "");

    widget.todoRepository.addToDo(todo);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.4,
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "ToDo hinzufügen",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Title eingeben"),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(hintText: "Text eingeben"),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => addTodo(),
                  child: Center(
                    child: Text("Todo in der DB hinzufügen"),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
