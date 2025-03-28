import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';
import 'package:testvlapp/features/auth/screens/password_reset.dart';
import 'package:testvlapp/features/auth/screens/phone_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;
  const LoginScreen({super.key, required this.authRepository});

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
    errorText = await widget.authRepository
        .signInWithEmailPassword(emailController.text, passwordController.text);

    setState(() {});
  }

  void register() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bitte E-Mail oder Password ausfüllen")));
      return;
    }

    // Nutzer registrieren
    errorText = await widget.authRepository.registerWithEmailPassword(
        emailController.text, passwordController.text);
    setState(() {});
  }

  void googleLogin() async {
    errorText = await widget.authRepository.signInWithGoogle();

    setState(() {});
  }

  void passwordReset() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordResetScreen(
                  authRepository: widget.authRepository,
                )));
  }

  void phoneLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhoneScreen(
                  authRepository: widget.authRepository,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            TextButton(
                onPressed: passwordReset, child: Text("Passwort vergessen?")),
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
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () => googleLogin(),
                child: Center(
                  child: Text("Google Login"),
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () => phoneLogin(),
                child: Center(
                  child: Text("Phone Login"),
                )),
          ],
        ),
      ),
    );
  }
}
