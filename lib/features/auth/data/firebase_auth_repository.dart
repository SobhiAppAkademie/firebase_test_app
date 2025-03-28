import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';
import 'package:testvlapp/features/auth/models/sms_response.dart';

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
          return "Diese E-Mail-Adresse wird bereits verwendet.";
        case 'invalid-email':
          return "Die eingegebene E-Mail-Adresse ist ungültig.";
        case 'weak-password':
          return "Das Passwort ist zu schwach. Bitte wählen Sie ein stärkeres Passwort.";
        case 'operation-not-allowed':
          return "Die Registrierung mit E-Mail und Passwort ist derzeit nicht aktiviert.";
        default:
          return "Ein unbekannter Fehler ist aufgetreten: ${e.message}";
      }
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
        case 'invalid-email':
          return "Die E-Mail-Adresse ist ungültig.";
        case 'user-disabled':
          return "Dieses Benutzerkonto wurde deaktiviert.";
        case 'user-not-found':
          return "Kein Benutzer gefunden. Bitte registrieren Sie sich.";
        case 'wrong-password':
          return "Falsches Passwort. Bitte versuchen Sie es erneut.";
        case 'too-many-requests':
          return "Zu viele fehlgeschlagene Anmeldeversuche. Bitte versuchen Sie es später erneut.";
        default:
          return "Ein unbekannter Fehler ist aufgetreten: ${e.message}";
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

  @override
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print(error);
        print(stacktrace);
      }

      return "Ein Fehler ist aufgetreten: $error";
    }
  }

  // Gibt eine VerificationID aus oder eine Fehlermeldung
  @override
  Future<SmsResponse> sendSMSCode(String phone) async {
    // Der Completer wird verwendet, damit wir warten, bis die verifyPhoneNumber
    // fertig ist und wir dann entweder die Fehlermeldung oder die verificationID
    // zurücl geben können
    Completer<String> completer = Completer();
    String? errorText;

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          if (e.code == 'invalid-phone-number') {
            errorText = 'Bitte gib eine gültige Telefonnummer ein.';
          } else {
            errorText = 'Verifizierung fehlgeschlagen: ${e.message}';
          }
          completer.completeError(errorText!);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    try {
      final verificationId = await completer.future;
      return SmsResponse(verificationId: verificationId, errorText: null);
    } catch (e) {
      print("Fehler: $e");
      return SmsResponse(verificationId: "", errorText: e.toString());
    }
  }

  // Phone Login: Einloggen mit der VerificationID und dem SMS Code
  @override
  Future<String?> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);
      return null;
    } catch (e) {
      return "Fehler: $e";
    }
  }
}
