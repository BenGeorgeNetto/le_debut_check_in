import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:le_debut_check_in/colors.dart';
import 'package:le_debut_check_in/screens/checkedin_participants.dart';
import 'package:le_debut_check_in/screens/yet_to_checkin.dart';
import 'package:le_debut_check_in/utilities/barcode_scanner_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le Debut'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('count_day2').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final checkedIn = snapshot.data!.docs[0]['value'];
          final remaining = snapshot.data!.docs[1]['value'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Checked In:',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text(checkedIn.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Remaining:',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                remaining.toString(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CheckedInParticipants(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0))),
                            padding: const EdgeInsets.all(16.0),
                            elevation: 8.0,
                            backgroundColor: surfColor,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Checked In Participants'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const YetToCheckin(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(24.0))),
                            padding: const EdgeInsets.all(16.0),
                            elevation: 8.0,
                            backgroundColor: surfColor,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Not Checked In Participants'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BarcodeScannerWithController(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16.0),
              elevation: 8.0,
              backgroundColor: psybeamColor,
              foregroundColor: Colors.black,
              fixedSize: const Size(64, 64)),
          child: const Icon(Icons.qr_code_2),
        ),
      ),
    );
  }
}