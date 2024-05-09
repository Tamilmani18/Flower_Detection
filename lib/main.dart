import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flower_detection_app/pages/home_page.dart';

void main() async{
  // initializing firebase
  WidgetsFlutterBinding.ensureInitialized(); // ensures bindings for native platform
  if (kIsWeb) {
    // for web
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyDYG1yE_hlCsJBYYlylc9gJo2HmR-6FSYw",
        authDomain: "flower-detection-app-1b7ed.firebaseapp.com",
        projectId: "flower-detection-app-1b7ed",
        storageBucket: "flower-detection-app-1b7ed.appspot.com",
        messagingSenderId: "280283897162",
        appId: "1:280283897162:web:4af93a266265296195f5b3",
        measurementId: "G-071TPEQ5G5"));
  } else {
    // for android and ios
    await Firebase.initializeApp();
  }

  runApp(const MaterialApp(
    home: FlowerDetectionApp(),
  ));
}

class FlowerDetectionApp extends StatelessWidget {
  const FlowerDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // title: 'Flower Detection App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
