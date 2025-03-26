import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/login_repository.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final LoginRepository loginRepository;
  const HomeScreen(
      {super.key, required this.user, required this.loginRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(user.email!),
          SizedBox(
            height: 2,
          ),
          Text(user.uid),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () => loginRepository.logOut(),
              child: Center(
                child: Text("Ausloggen"),
              ))
        ],
      ),
    );
  }
}
