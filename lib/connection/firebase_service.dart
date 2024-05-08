import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Accessing the Firestore collection and fetch the document by ID
Future<String?> fetchFlowerName(String documentId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('flowers')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      // Document exists, retrieve the data
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return data['Name']; // 'Name' field containing flower name
    } else {
      // Document does not exist
      return null;
    }
  } catch (e) {
    // Error occurred
    if (kDebugMode) {
      print('Error fetching flower name: $e');
    }
    return null;
  }
}

/*

body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("flowers").snapshots(),
      builder:(context,snapshot){
        if ( snapshot.connectionState == ConnectionState.active ) {
          if ( snapshot.hasData ) {
            return ListView.builder(itemBuilder: (context,index){
              return ListTile(
              leading: CircleAvatar(
                  child: Text("${index+1}"),
                ),
                title: Text("${snapshot.data!.docs[index]["title"]}"),
                subtitle: Text("${snapshot.data!.docs[index]["description"]}"),
              );
            })
          }
          else if ( snapshot.hasError ) {
            return Center(child: Text("${snapshot.hasError.toString}"),);
          }
          else {

          }
        }
      })

*/