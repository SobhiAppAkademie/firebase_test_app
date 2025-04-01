import 'package:testvlapp/features/todo/models/todo.dart';

abstract class TodoRepository {
  // Todo in der DB hinzufügen
  Future<void> addToDo(Todo todo);

  // Todo in der DB löschen
  Future<void> deleteToDo(String docID);

  // Todo in der DB updaten (isDone)
  Future<void> updateToDoState(String docID, bool value);

  Stream<List<Todo>> getTodos();
}
