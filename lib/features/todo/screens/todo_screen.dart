import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/screens/components/unfinished_todos_widget.dart';
import 'package:testvlapp/features/todo/screens/todo_add_screen.dart';
import 'package:testvlapp/features/todo/screens/todo_finished_screen.dart';

class TodoScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  const TodoScreen({super.key, required this.todoRepository});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void openAddModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => TodoAddScreen(
              todoRepository: widget.todoRepository,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ToDo",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoFinishedScreen(
                                      todoRepository: widget.todoRepository))),
                          child: CircleAvatar(
                            child: Icon(Icons.check),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => openAddModal(),
                          child: CircleAvatar(
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                UnfinishedTodosWidget(todoRepository: widget.todoRepository)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
