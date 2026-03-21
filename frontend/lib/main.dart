import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyALso95bcnMxj6iRgp_RulD4kH_sy6_Gek",
      authDomain: "shubhvastu-ff6f9.firebaseapp.com",
      projectId: "shubhvastu-ff6f9",
      storageBucket: "shubhvastu-ff6f9.appspot.com",
      messagingSenderId: "715560634065",
      appId: "1:715560634065:web:3f367666024b07c8daa7f0",
      measurementId: "G-H5VKSXBDXW"
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
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
      routes: {
        '/': (context) => const WelcomeScreen(),
      },
      initialRoute: '/',
    );
  }
}
