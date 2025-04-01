import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';
import 'package:testvlapp/features/todo/screens/todo_add_screen.dart';

class TodoScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  const TodoScreen({super.key, required this.todoRepository});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void addToDo() {
    showModalBottomSheet(
        context: context,
        builder: (context) => TodoAddScreen(
              todoRepository: widget.todoRepository,
            ));
  }

  void deleteToDo(String docID) {
    widget.todoRepository.deleteToDo(docID);
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
                    GestureDetector(
                      onTap: () => addToDo(),
                      child: CircleAvatar(
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<List<Todo>>(
                    stream: widget.todoRepository.getTodos(),
                    builder: (context, snapshot) {
                      // Fall 1: Fehler aufgetreten
                      if (snapshot.hasError) {
                        return Text("Fehler: ${snapshot.error}");
                      } else if (snapshot.connectionState ==
                              ConnectionState.active &&
                          !snapshot.hasData) {
                        // Fall 2: Wir laden noch
                        return CupertinoActivityIndicator();
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final todos = snapshot.data!;
                        // Fall 3: Wir haben Daten
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return CheckboxListTile.adaptive(
                                title: Text(todo.title),
                                subtitle: Text(todo.text),
                                value: todo.isDone,
                                secondary: GestureDetector(
                                  onTap: () => deleteToDo(todo.docID),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                                onChanged: (value) {},
                              );
                            });
                      }

                      // Fall 4: Verbindung erfolgreich, aber keine Daten vorhanden
                      return Text("Keine Daten");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
