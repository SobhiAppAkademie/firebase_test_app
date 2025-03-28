import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';

class PasswordResetScreen extends StatefulWidget {
  final AuthRepository authRepository;
  const PasswordResetScreen({super.key, required this.authRepository});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final emailController = TextEditingController();

  String? errorText;

  void passwordReset() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Bitte E-Mail eingeben")));
      return;
    }

    errorText = await widget.authRepository.resetPassword(emailController.text);

    setState(() {});
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "E-Mail"),
              controller: emailController,
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
              height: 15,
            ),
            ElevatedButton(
                onPressed: () => passwordReset(),
                child: Text("Password zurücksetzen")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: goBack, child: Text("Zurück")),
          ],
        ),
      ),
    ));
  }
}
