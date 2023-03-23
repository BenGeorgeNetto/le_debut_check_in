import 'package:flutter/material.dart';
import 'package:le_debut_check_in/colors.dart';
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
      body: const Center(
        child: Text('Press the button to check in'),
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
