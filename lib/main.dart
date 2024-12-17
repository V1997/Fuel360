import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Add your Firebase configuration here
    // You can get this from the Firebase Console
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Your App Name',
      home: LoginScreen(),
    );
  }
}