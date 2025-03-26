import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/login_repository.dart';
import 'package:testvlapp/features/auth/screens/home.dart';
import 'package:testvlapp/features/auth/screens/login.dart';
import 'package:testvlapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Auth Instanz
  FirebaseAuth auth = FirebaseAuth.instance;

  // Login Repository
  final loginRepository = LoginRepository(auth);

  runApp(App(loginRepository: loginRepository));
}

class App extends StatelessWidget {
  final LoginRepository loginRepository;

  const App({super.key, required this.loginRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      /// Echtzeit-Abfrage, um zu überprüfen, ob der Nutzer authentifiziert ist
      home: StreamBuilder<User?>(
          stream: loginRepository.onAuthChanged,
          builder: (context, snapshot) {
            /// User ist authentifiziert
            if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!;
              return HomeScreen(user: user, loginRepository: loginRepository);
            }
            return LoginScreen(loginRepository: loginRepository);
          }),
    );
  }
}
