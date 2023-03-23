import 'package:cloud_firestore/cloud_firestore.dart';

void updateCheckinStatus(String checksum) async{

  final parts = checksum.split('-');
  print(parts[3]);

  final participants = FirebaseFirestore.instance.collection('participant');

  final document = participants.doc(parts[3]);

  await document.update({
    'checkedIn': "TRUE",
  });

}

// void printDocuments() async {
//   // Get a reference to the Firestore instance
//   final firestore = FirebaseFirestore.instance;
//
//   // Get a reference to the collection where your documents are stored
//   final collection = firestore.collection('participant');
//
//   // Retrieve all documents from the collection
//   final querySnapshot = await collection.get();
//
//   // Print the data of each document
//   for (final document in querySnapshot.docs) {
//     print(document.data());
//   }
// }