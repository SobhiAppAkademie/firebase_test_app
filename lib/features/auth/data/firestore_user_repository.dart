import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testvlapp/features/auth/data/user_repository.dart';
import 'package:testvlapp/features/auth/models/database_user.dart';

class FirestoreUserRepository implements UserRepository {
  // Konstruktor
  FirestoreUserRepository(this._db);

  // Firestore-Instanz
  final FirebaseFirestore _db;

  @override
  Future<DatabaseUser?> getUser(String uid) async {
    // Dokument abrufen: collection: users -> document: uid
    final doc = await _db.collection("users").doc(uid).get();

    // Überprüfen ob das Dokument existiert
    if (doc.exists) {
      // Auf Map zugreifen
      final data = doc.data();
      if (data != null) {
        // DatenbankUser zurückgeben
        return DatabaseUser.fromMap(data);
      }
    }

    // Dokument existiert nicht, also auch kein User
    return null;
  }

  @override
  Future<List<DatabaseUser>> getAllUsers() async {
    final dbDocs = await _db.collection("users").get();

    List<DatabaseUser> users = [];

    for (var doc in dbDocs.docs) {
      users.add(DatabaseUser.fromMap(doc.data()));
    }

    return users;
  }
}
