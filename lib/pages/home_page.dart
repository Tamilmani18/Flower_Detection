import 'package:flutter/material.dart';
import 'package:flower_detection_app/pages/image_page.dart';
import 'package:hexcolor/hexcolor.dart';

class FlowerDetectionApp extends StatelessWidget {
  const FlowerDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8b4b59"),
        title: const Text(
          "Flower Detection",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            // fontFamily: 'ArchivoBlack',
            // color: HexColor("#8b4b59"),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const PickImage(),
    );
  }
}
