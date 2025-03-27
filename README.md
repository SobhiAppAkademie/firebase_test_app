# Firebase Authentication

## Vorgehen, um die Firebase Authentication zu implementieren

1. Abstrake Klasse anlegen mit den jeweiligen Methoden und Klassenattribut wie: login(), logout(), authStateChanges
2. Ein FirebaseAuthRepository erstellen welches die abstrakte Klasse implementiert
3. In der main.dart eine Instanz der FirebaseAuthRepository erstellen
4. Die Instanz bis zu den Screens übergeben
