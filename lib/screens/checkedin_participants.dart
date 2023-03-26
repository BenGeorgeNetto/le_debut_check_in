import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:le_debut_check_in/screens/participant_details.dart';

class CheckedInParticipants extends StatefulWidget {
  const CheckedInParticipants({Key? key}) : super(key: key);

  @override
  State<CheckedInParticipants> createState() => _CheckedInParticipantsState();
}

class _CheckedInParticipantsState extends State<CheckedInParticipants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checked In Participants'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('participants_day2')
              .where('checkedIn', isEqualTo: "TRUE")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(toTitleCase(data['name'])),
                    subtitle: Text(data['email']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParticipantDetails(
                            checksum: data['checksum'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  String toTitleCase(String text) {
    final buffer = StringBuffer();
    final regex = RegExp(r'(\w+)');
    for (final match in regex.allMatches(text)) {
      buffer.write(match.group(1)![0].toUpperCase());
      buffer.write(match.group(1)?.substring(1).toLowerCase());
      buffer.write(' ');
    }
    return buffer.toString().trim();
  }
}
