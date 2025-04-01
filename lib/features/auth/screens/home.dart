import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';
import 'package:testvlapp/features/auth/data/user_repository.dart';
import 'package:testvlapp/features/todo/data/todo_repository.dart';
import 'package:testvlapp/features/todo/screens/todo_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final TodoRepository todoRepository;
  const HomeScreen(
      {super.key,
      required this.user,
      required this.authRepository,
      required this.todoRepository,
      required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(user.email ?? user.phoneNumber ?? "n.a"),
          SizedBox(
            height: 2,
          ),
          Text(user.uid),
          SizedBox(
            height: 5,
          ),
          FutureBuilder(
              future: userRepository.getUser(user.uid),
              builder: (context, snapshot) {
                // 1.Fall: Wir haben Daten
                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  return Text("Name vom User: ${user.name}");
                } else if (snapshot.connectionState != ConnectionState.done) {
                  // 2.Fall: Laden der Daten
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 3. Fall: Haben einen Fehler
                  return Text("Fehler: ${snapshot.error!}");
                } else {
                  // 4. Fall: Keine Daten
                  return Text("Keine Daten");
                }
              }),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TodoScreen(
                            todoRepository: todoRepository,
                          ))),
              child: Text("To-Do's")),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () => authRepository.logOut(),
              child: Center(
                child: Text("Ausloggen"),
              ))
        ],
      ),
    );
  }
}
