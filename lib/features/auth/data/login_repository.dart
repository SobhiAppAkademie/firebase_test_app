import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  LoginRepository(this._auth);
  final FirebaseAuth _auth;

  /// Um auf ein Stream zuzuhören
  Stream<User?> get onAuthChanged => _auth.authStateChanges();

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'email-already-in-use':
          return "E-Mail ist bereits vergeben";
      }
      return "Fehler ist aufgetreten";
    }
    return null;
  }

  /// Login
  Future<String?> login(String email, String password) async {
    // Try-Catch, um User zu authentifizieren
    try {
      // Authentifizierungsmethode aufrufen
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Authentifizierungsfehler abfangen
      print(e.code);
      switch (e.code) {
        case "invalid-credential":
          return "Falsche Anmeldedaten";
      }
    }
    return null;
  }

  /// Logout
  Future<void> logOut() async {
    await _auth.signOut();
  }
}
