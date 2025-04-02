import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';

class TodoUpdateScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  final Todo todo;
  const TodoUpdateScreen(
      {super.key, required this.todoRepository, required this.todo});

  @override
  State<TodoUpdateScreen> createState() => _TodoUpdateScreenState();
}

class _TodoUpdateScreenState extends State<TodoUpdateScreen> {
  late final TextEditingController titleController;
  late final TextEditingController textController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.todo.title);
    textController = TextEditingController(text: widget.todo.text);
    super.initState();
  }

  void updateTodo() {
    final String title = titleController.text;
    final String text = textController.text;

    widget.todoRepository.updateToDo(widget.todo.docID, title, text);

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
                "ToDo bearbeiten",
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
                  onPressed: () => updateTodo(),
                  child: Center(
                    child: Text("Todo in der DB updaten"),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
