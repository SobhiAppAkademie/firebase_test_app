# 🔐 Firebase Authentication in Flutter implementieren (inkl. Google Login)

Diese Anleitung führt dich Schritt für Schritt durch die Einrichtung von Firebase Authentication mit einer sauberen Architektur – inklusive Google Login.

---

## 📦 Voraussetzungen

- Flutter-Projekt
- Firebase-Projekt eingerichtet (inkl. iOS/Android App registriert)
- Firebase SDK integriert

---

## 🛠️ Firebase Authentication einrichten

### 1. Firebase-Paket hinzufügen

In der `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.12.1
  firebase_auth: ^5.5.1
```

Dann installieren mit:

```bash
flutter pub get
```

Firebase initialisieren:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

---

## 🧱 Authentifizierungsstruktur aufbauen

### 2. 🔧 Abstrakte Auth-Klasse definieren

```dart
abstract class AuthRepository {
  Future<String?> signInWithEmailPassword(String email, String password);
  Future<String?> registerWithEmailPassword(String email, String password);
  Future<void> logOut();
  Future<String?> signInWithGoogle();
  Stream<dynamic> onAuthChanged();
}
```

---

### 3. 🏗️ `FirebaseAuthRepository` erstellen

Diese Klasse implementiert die abstrakte Klasse mit konkreter Firebase-Logik:

```dart
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
```

---

## 🧬 Repository im Projekt nutzen

### 4. `main.dart`: Repository-Instanz erstellen

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Auth Instanz
  FirebaseAuth auth = FirebaseAuth.instance;

  // Login Repository
  final AuthRepository authRepository = FirebaseAuthRepository(auth);
}
```

### 5. Repository durch die Widget-Tree weitergeben

Z.B. mit `Provider` oder direkt über den Konstruktor:

```dart
class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: authRepository.onAuthChanged() as Stream<User?>,
          builder: (context, snapshot) {
            /// User ist authentifiziert
            if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!;
              return HomeScreen(user: user, authRepository: authRepository);
            }
            return LoginScreen(authRepository: authRepository);
          }),
    );
  }
}
```

---

## 🔐 Google Login aktivieren

### 1. `google_sign_in` Plugin hinzufügen

In `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^6.1.0
```

---

### 2. Google-Login-Code in `FirebaseAuthRepository` (siehe oben) ✅

- `signInWithGoogle()` Methode
- `logout()` Methode ergänzt um `GoogleSignIn().signOut()`

---

### 3. Im Firebase-Console den Google Provider aktivieren

**Schritte:**
- Authentifizierung > Sign-in-Methoden
- Google aktivieren und speichern

---

### 4. Konfigurationsdaten aktualisieren

⚠️ Falls du den Google-Provider **neu** aktivierst, solltest du zur Sicherheit:
- die `google-services.json` (Android)
- und `GoogleService-Info.plist` (iOS)

**neu herunterladen und ersetzen.**

---

### 5. iOS Konfiguration anpassen (`ios/Runner/Info.plist`)

```xml
<key>GIDClientID</key>
<string><!-- Hier die CLIENT_ID aus der GoogleService-Info.plist --></string>

<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string><!-- Hier REVERSE_CLIENT_ID, z.B. com.googleusercontent.apps.xyz --></string>
    </array>
  </dict>
</array>
```

Tipp: Die `REVERSE_CLIENT_ID` findest du ebenfalls in der `GoogleService-Info.plist`.

---

### 6. Android Konfiguration anpassen (`android/app/build.gradle`)

In der defaultConfig die minSdk = 23 setzen

```gradle
 defaultConfig {
      
        applicationId = "com.example.testvlapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
```



---

### 7. Funktion testen 🎉

- App starten
- Auf "Mit Google anmelden" klicken
- Authentifizierung prüfen

---

## ✅ Fazit

Du hast nun:
- eine saubere Abstraktion für Authentifizierung
- Firebase- und Google-Login integriert
- das Ganze modular und testbar aufgebaut 💪

---
