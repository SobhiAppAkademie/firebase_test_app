import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';
import 'package:testvlapp/features/auth/data/firebase_auth_repository.dart';
import 'package:testvlapp/features/auth/data/firestore_user_repository.dart';
import 'package:testvlapp/features/auth/data/user_repository.dart';
import 'package:testvlapp/features/auth/screens/home.dart';
import 'package:testvlapp/features/auth/screens/login.dart';
import 'package:testvlapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Auth Instanz
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore Instanz
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Repository
  final AuthRepository authRepository = FirebaseAuthRepository(auth);
  final UserRepository userRepository = FirestoreUserRepository(firestore);

  runApp(App(
    authRepository: authRepository,
    userRepository: userRepository,
  ));
}

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  const App(
      {super.key, required this.authRepository, required this.userRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: authRepository.onAuthChanged() as Stream<User?>,
        builder: (context, snapshot) {
          // Es reicht zu überprüfen, ob wir einen User haben
          final isLoggedIn = snapshot.data != null;
          final user = snapshot.data;
          return MaterialApp(
              key: isLoggedIn ? Key("logged_in") : Key("not_logged_in"),
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: isLoggedIn
                  ? HomeScreen(
                      user: user!,
                      authRepository: authRepository,
                      userRepository: userRepository,
                    )
                  : LoginScreen(authRepository: authRepository));
        });
  }
}
