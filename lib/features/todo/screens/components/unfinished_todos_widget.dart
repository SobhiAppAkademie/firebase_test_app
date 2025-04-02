import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';
import 'package:testvlapp/features/todo/screens/todo_update_screen.dart';

class UnfinishedTodosWidget extends StatelessWidget {
  final TodoRepository todoRepository;
  const UnfinishedTodosWidget({super.key, required this.todoRepository});

  void openUpdateModal(Todo todo, BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => TodoUpdateScreen(
              todoRepository: todoRepository,
              todo: todo,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
        stream: todoRepository.getTodos(false),
        builder: (context, snapshot) {
          // Fall 1: Fehler aufgetreten
          if (snapshot.hasError) {
            print(snapshot.error!);
            return Text("Fehler: ${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            // Fall 2: Wir laden noch
            return CupertinoActivityIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            final todos = snapshot.data!;

            if (todos.isEmpty) {
              return Center(
                child: Text("Keine Todos"),
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
                  return GestureDetector(
                    onLongPress: () => openUpdateModal(todo, context),
                    child: CheckboxListTile.adaptive(
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
                      onChanged: (value) {
                        if (value != null) {
                          todoRepository.updateToDoState(todo.docID, value);
                        }
                      },
                    ),
                  );
                });
          }

          // Fall 4: Verbindung erfolgreich, aber keine Daten vorhanden
          return Text("Keine Daten");
        });
  }
}
