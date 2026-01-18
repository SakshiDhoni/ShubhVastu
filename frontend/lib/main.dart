import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase. If you generated firebase_options.dart, use that instead.
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyALso95bcnMxj6iRgp_RulD4kH_sy6_Gek",
  authDomain: "shubhvastu-ff6f9.firebaseapp.com",
  projectId: "shubhvastu-ff6f9",
  storageBucket: "shubhvastu-ff6f9.firebasestorage.app",
  messagingSenderId: "715560634065",
  appId: "1:715560634065:web:3f367666024b07c8daa7f0",
  measurementId: "G-H5VKSXBDXW"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapnaVastu',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      // Define routes for navigation
      routes: {
        '/' : (context) => const WelcomeScreen(),
      },
      initialRoute: '/',
    );
  }
}
