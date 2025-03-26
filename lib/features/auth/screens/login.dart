import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/login_repository.dart';

class LoginScreen extends StatefulWidget {
  final LoginRepository loginRepository;
  const LoginScreen({super.key, required this.loginRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorText;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bitte E-Mail oder Password ausfüllen")));
      return;
    }

    // Nutzer einloggen
    errorText = await widget.loginRepository
        .login(emailController.text, passwordController.text);

    setState(() {});
  }

  void register() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bitte E-Mail oder Password ausfüllen")));
      return;
    }

    // Nutzer registrieren
    errorText = await widget.loginRepository
        .register(emailController.text, passwordController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(hintText: "E-Mail"),
            controller: emailController,
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Passwort"),
            controller: passwordController,
          ),
          SizedBox(
            height: 10,
          ),
          if (errorText != null)
            Text(
              errorText!,
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => login(),
              child: Center(
                child: Text("Login"),
              )),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => register(),
              child: Center(
                child: Text("Registrieren"),
              ))
        ],
      ),
    );
  }
}
