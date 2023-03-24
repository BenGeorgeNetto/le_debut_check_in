import 'package:cloud_firestore/cloud_firestore.dart';

void getParticipantsCountTrue() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('participant')
      .where('checkedIn', isEqualTo: 'TRUE')
      .get();

  final countDoc = FirebaseFirestore.instance
      .collection('count');

  countDoc.doc('checkedIn').update({
    'value': snapshot.docs.length,
  });
}

void getParticipantsCountFalse() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('participant')
      .where('checkedIn', isEqualTo: 'FALSE')
      .get();

  final countDoc = FirebaseFirestore.instance
      .collection('count');

  countDoc.doc('remaining').update({
  'value': snapshot.docs.length,
  });
}