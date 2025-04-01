import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/models/todo.dart';

class FirestoreTodoRepository implements TodoRepository {
  final FirebaseFirestore _db;

  FirestoreTodoRepository(this._db);

  @override
  Future<void> addToDo(Todo todo) async {
    await _db.collection("todos").add(todo.toMap());
  }

  @override
  Future<void> deleteToDo(String docID) async {
    await _db.collection("todos").doc(docID).delete();
  }

  @override
  Future<void> updateToDoState(String docID, bool value) {
    // TODO: implement updateToDoState
    throw UnimplementedError();
  }

  @override
  Stream<List<Todo>> getTodos() {
    return _db.collection("todos").snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Todo.fromMap(doc.data(), doc.id)).toList());
  }
}
