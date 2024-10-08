import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'flower_details.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {

  File? filePath;
  String? _generatedId;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  void loadModel() async {
    await Tflite.loadModel(
      // model: 'assets/neural_model.tflite',
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });
  }

  void performInference() async {

    final List<dynamic>? result = await Tflite.runModelOnImage(
      path: filePath!.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (kDebugMode) {
      print('Logging result var: $result');
    }

    if (result != null && result.isNotEmpty) {
      String? flowerId;
      for (var element in result) {
        if (element is Map<Object?, Object?>) {
          final dynamic indexValue = element['index'];
          if (indexValue != null && indexValue is int) {
            flowerId = indexValue.toString();
            break;
          }
        } else if (element is String) {
          final parts = element.split(' ');
          if (parts.length >= 2) {
            flowerId = parts[0];
            break;
          }
        }
      }

      setState(() {
        _generatedId = flowerId;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlowerDetails(
            imageFile: filePath,
            generatedId: _generatedId,
          ),
        ),
      );
    } else {
      setState(() {
        _generatedId = null;
      });
    }
  }

  @override
  // void dispose() {
  //   Tflite.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 55,
              ),
              Card(
                elevation: 10,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: 365,
                  width: 335,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            image: filePath != null
                                ? DecorationImage(
                              image: FileImage(filePath!),
                              fit: BoxFit.cover,
                            )
                                : const DecorationImage(
                              image: AssetImage('images/upload.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                "Upload",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageCamera();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: HexColor("#ebe5f3"), // bde0fe 8b4b59 03045e 023e8a 3a86ff
                ),
                child: const Text("Take a Photo"),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageGallery();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: HexColor("#ebe5f3"),
                ),
                child: const Text("Choose from gallery"),
              ),
              const SizedBox(
                height: 28,
              ),
              ElevatedButton(
                onPressed: () {
                  performInference();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: HexColor("#ebe5f3"), // a881af 3a86ff ebe5f3
                ),
                child: const Text("Search Flower"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
