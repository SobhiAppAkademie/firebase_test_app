import 'dart:async';

import 'package:collection/collection.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';
import 'package:testvlapp/features/auth/models/user_data.dart';

class MockAuthRepository implements AuthRepository {
  // Simulierte User-Liste in der Datenbank
  final List<UserData> users = [];

  // Nutzen einen Stream-Controller, um den Login-Fluss zu steuern
  StreamController<UserData?> streamController = StreamController<UserData?>();

  // Simulieren den State
  @override
  Stream<dynamic> onAuthChanged() => streamController.stream;

  // Ausloggen
  @override
  Future<void> logOut() async {
    // Ausloggen simulieren
    streamController.add(null);
  }

  // Registrieren
  @override
  Future<String?> registerWithEmailPassword(
      String email, String password) async {
    // Ist der User bereits in der "simulierten Datenbank-Liste vorhanden"?
    final foundUser = users.firstWhereOrNull((user) => user.email == email);

    // Wenn ja, dann Fehler zurück geben
    if (foundUser != null) {
      return "User existiert bereits";
    } else {
      // Wenn nein, User in der "simulierten Datenbank-Liste hinzufügen"
      final user = UserData(
          email: email, password: password, uid: "${users.length + 1}");

      // Fügen unseren Nutzer in unsere simulierte Datenbank-Liste hinzu
      users.add(user);

      // und login simulieren
      streamController.add(user);
    }
    return null;
  }

  @override
  Future<String?> signInWithEmailPassword(String email, String password) async {
    // Existiert ein Nutzer überhaupt?
    final foundUser = users.firstWhereOrNull((user) => user.email == email);

    // Wenn nein, Fehlermeldung zurück geben
    if (foundUser == null) {
      return "Der Benutzer existiert nicht";
    } else {
      // Wenn ja, das Passwort vergleichen und login simulieren
      if (foundUser.password == password) {
        // Login simulieren
        streamController.add(foundUser);
        return null;
      } else {
        // Fehlermeldung zurückgeben
        return "Passwort stimmt nicht überein";
      }
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    // Hardcoded Google-Account
    String googleTestEmail = "test@google.com";

    // Existiert der Google-Account bereits in der Liste?
    final foundUser =
        users.firstWhereOrNull((user) => user.email == googleTestEmail);

    // Wenn nein, dann fügen wir ihn in unsere simulierte Datenbank-Liste hinzu und simulieren
    // ein loggen
    if (foundUser == null) {
      final user = UserData(
          email: googleTestEmail,
          password: googleTestEmail,
          uid: "${users.length + 1}");
      users.add(user);
    }
    streamController.add(foundUser);
    return null;
  }
}
