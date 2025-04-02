import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';

class FinishedTodosWidget extends StatelessWidget {
  final TodoRepository todoRepository;
  const FinishedTodosWidget({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
        stream: todoRepository.getTodos(true),
        builder: (context, snapshot) {
          // Fall 1: Fehler aufgetreten
          if (snapshot.hasError) {
            return Text("Fehler: ${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            // Fall 2: Wir laden noch
            return CupertinoActivityIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            final todos = snapshot.data!;

            if (todos.isEmpty) {
              return Center(
                child: Text("Keine fertigen Todos"),
              );
            }
            // Fall 3: Wir haben Daten
            return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return CheckboxListTile.adaptive(
                    title: Text(todo.title),
                    subtitle: Text(todo.text),
                    value: todo.isDone,
                    secondary: GestureDetector(
                      onTap: () => todoRepository.deleteToDo(todo.docID),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                    ),
                    onChanged: (_) {},
                  );
                });
          }

          // Fall 4: Verbindung erfolgreich, aber keine Daten vorhanden
          return Text("Keine Daten");
        });
  }
}
