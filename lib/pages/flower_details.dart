import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flower_detection_app/connection/firebase_service.dart';

class FlowerDetails extends StatelessWidget {
  final File? imageFile;
  final String? generatedId;
  const FlowerDetails({super.key, this.imageFile, this.generatedId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8b4b59"),
        title: const Text(
          "Flower Details",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Material(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: generatedId != null ? fetchFlowerData(generatedId!) : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    Map<String, dynamic>? flowerData = snapshot.data;
                    if (flowerData != null) {
                      String flowerName = flowerData['Name'] ?? 'Flower name not found';
                      String breed = flowerData['Breed'] ?? 'Breed not found';
                      String detail = flowerData['Detail'] ?? 'Detail not found';
                      String scientificName = flowerData['ScientificName'] ?? 'Scientific Name not found';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              scientificName,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'ArchivoBlack',
                                color: HexColor("#8b4b59"),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              flowerName,
                              style: TextStyle(
                                fontSize: 20,
                                color: HexColor("#ecd131"),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: ClipOval(
                                child: imageFile != null
                                    ? Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'images/flowerss.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Breed: $breed',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Details: $detail',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Next page for more details
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
                              ),
                              child: Text(
                                'More Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: HexColor("#8b4b59"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){},
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){},
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){},
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return const Center(child: Text('Flower data not found'));
                    }
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
