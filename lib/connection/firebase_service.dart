import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// To fetch all data from firebase collection
Future<Map<String, dynamic>?> fetchFlowerData(String documentId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('flowers')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching flower data: $e');
    }
    return null;
  }
}

// // Accessing the Firestore collection and fetch the document by ID
// Future<String?> fetchFlowerName(String documentId) async {
//   try {
//     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//         .collection('flowers')
//         .doc(documentId)
//         .get();
//
//     if (documentSnapshot.exists) {
//       // Document exists, retrieve the data
//       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//       return data['Name']; // 'Name' field containing flower name
//     } else {
//       // Document does not exist
//       return null;
//     }
//   } catch (e) {
//     // Error occurred
//     if (kDebugMode) {
//       print('Error fetching flower name: $e');
//     }
//     return null;
//   }
// }