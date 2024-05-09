import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flower_detection_app/connection/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:share/share.dart';


class FlowerDetails extends StatelessWidget {
  final File? imageFile;
  final String? generatedId;
  const FlowerDetails({super.key, this.imageFile, this.generatedId});

  Future<void> _launchGoogleSearch(String query, {bool inApp = false}) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final url = 'https://www.google.com/search?q=$encodedQuery';
    if (await canLaunch(url)) {
      if (inApp) {
        await launch(url, forceWebView: true);
      } else {
        await launch(url);
      }
    } else {
      print('Could not launch $url');
    }
  }

  // Future<void> _shareFlower(String flowerName) async {
  //   Share.share('Check out this beautiful flower: $flowerName');
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a86ff"), //  8b4b59 3a86ff
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
                      String scientificName = flowerData['ScientificName'] ?? 'Scientific Name not found'; // Species

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              flowerName,
                              style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'ArchivoBlack',
                                color: Colors.black,
                                // color: HexColor("#ff8fa3"), // ef476f 5eb1bf
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              scientificName,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                // color: HexColor("#f4989c"), // maybe use another color
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
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Breed : ',
                                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: breed,
                                    style: const TextStyle(color: Colors.black54), // f4989c
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   child: Text(
                          //     'Breed: $breed',
                          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Details : ',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: detail,
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (flowerName != null && flowerName.isNotEmpty) {
                                  _launchGoogleSearch(flowerName);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.yellow,
                                backgroundColor: HexColor("#ebe5f3"),
                                padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
                              ),
                              child: const Text(
                                'More Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  // color: HexColor("#8b4b59"),
                                  color: Colors.black54,
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
                                  onTap: (){
                                    // _shareFlower(flowerName);
                                  },
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
