import 'package:flutter/material.dart';
import 'package:testvlapp/features/auth/data/auth_repository.dart';

class PhoneScreen extends StatefulWidget {
  final AuthRepository authRepository;
  const PhoneScreen({super.key, required this.authRepository});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  // Column: Inhalte von oben nach unten zu platzieren   (vertical)
  //    - mainAxis: vertikale Achse
  //    - crossAxis: horizontale Achse

  // Row:    Inhalte von links nach rechts zu platzieren (horizonzal)
  //    - mainAxis: horizontale Achse
  //    - crossAxis: vertikale Achse

  final phoneController = TextEditingController();
  final smsController = TextEditingController();

  String? errorText;

  String? verificationId;

  void loginInWithPhone() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bitte Telefonnummer eingeben")));
      return;
    }

    final smsResponse =
        await widget.authRepository.sendSMSCode(phoneController.text);

    if (smsResponse.errorText != null) {
      errorText = smsResponse.errorText;
    } else {
      verificationId = smsResponse.verificationId;

      // Setzen den Error zurück
      errorText = null;
    }

    setState(() {});
  }

  void verifySmsCode() async {
    if (smsController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Bitte SMS-Code eingeben")));
      return;
    }

    errorText = await widget.authRepository
        .signInWithPhoneNumber(verificationId!, smsController.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Telefonnummer"),
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: 10,
            ),
            if (errorText != null)
              Text(
                errorText!,
                style: TextStyle(color: Colors.red),
              ),

            // Wenn wir den SMS Code versendet haben, neues Textfeld anzeigen
            if (verificationId != null)
              SizedBox(
                height: 15,
              ),
            if (verificationId != null)
              TextField(
                decoration: InputDecoration(hintText: "SMS Code eingeben"),
                controller: smsController,
                keyboardType: TextInputType.number,
              ),
            SizedBox(
              height: 15,
            ),

            // SMS Code wurde versendet, und button soll verschwinden
            if (verificationId == null)
              ElevatedButton(
                  onPressed: loginInWithPhone,
                  child: Center(
                    child: Text("Mit Handy einloggen"),
                  )),

            // SMS Code wurde versendet, SMS Code soll überprüft werden
            if (verificationId != null)
              ElevatedButton(
                  onPressed: verifySmsCode,
                  child: Center(
                    child: Text("SMS Code überprüfen"),
                  ))
          ],
        ),
      ),
    );
  }
}
