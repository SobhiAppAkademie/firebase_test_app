import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  // Ausloggen (auch für Google, falls verwendet wird)
  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // Steuert den Kontrollfluss, ob ein User angemeldet ist oder nicht
  @override
  Stream<User?> onAuthChanged() => _auth.authStateChanges();

  // Nutzer mit E-Mail und Passwort registrieren
  @override
  Future<String?> registerWithEmailPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "E-Mail ist bereits vergeben";
      }
      return "Fehler ist aufgetreten";
    }
    return null;
  }

  // Nutzer mit E-Mail und Passwort einloggen
  @override
  Future<String?> signInWithEmailPassword(String email, String password) async {
    try {
      // Authentifizierungsmethode aufrufen
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Authentifizierungsfehler abfangen

      switch (e.code) {
        case "invalid-credential":
          return "Falsche Anmeldedaten";
      }
    }
    return null;
  }

  // Nutzer per Google einloggen
  @override
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('exception->$e');
      }
      return "Google-Fehler: $e";
    }
    return null;
  }
}
