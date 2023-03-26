import 'package:flutter/material.dart';
import 'package:le_debut_check_in/cloud_functions/set_value.dart';
import 'package:le_debut_check_in/colors.dart';
import 'package:le_debut_check_in/screens/participant_details.dart';
import 'package:le_debut_check_in/utilities/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerWithController> createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    detectionTimeoutMs: 2000,
    // returnImage: false,
  );

  bool isStarted = true;

  void _startOrStop() {
    try {
      if (isStarted) {
        controller.stop();
      } else {
        controller.start();
      }
      setState(() {
        isStarted = !isStarted;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 90,
                    child: Center(
                      child: FittedBox(
                        // height: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              barcode?.barcodes.first.rawValue ??
                                  'Ready to scan',
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Color(0xFFE5E1E6),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              MobileScanner(
                controller: controller,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.fitWidth,
                onDetect: (barcode) {
                  setState(() {
                    this.barcode = barcode;
                  });

                  try {
                    if (barcode.barcodes.first.displayValue!.contains("FNV") ||
                        barcode.barcodes.first.displayValue!.contains("VEG") ||
                        barcode.barcodes.first.displayValue!.contains("NOF")) {
                      //for debug
                      // printDocuments();

                      // for first day
                      // updateCheckinStatus(barcode.barcodes.first.displayValue!);

                      // for second day
                      updateCheckinStatusDay2(barcode.barcodes.first.displayValue!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParticipantDetails(
                              checksum: barcode.barcodes.first.displayValue),
                        ),
                      );
                    }
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                  }

                  // print(
                  //   'Data: ${barcode.barcodes.first.displayValue}',
                  // );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: controller.hasTorchState,
                        builder: (context, state, child) {
                          if (state != true) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            color: psybeamColor,
                            icon: ValueListenableBuilder(
                              valueListenable: controller.torchState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.grey,
                                  );
                                }
                                switch (state as TorchState) {
                                  case TorchState.off:
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  case TorchState.on:
                                    return const Icon(
                                      Icons.flash_on,
                                      color: Color(0xFFFFE27D),
                                    );
                                }
                              },
                            ),
                            iconSize: 24.0,
                            onPressed: () => controller.toggleTorch(),
                          );
                        },
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: isStarted
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: _startOrStop,
                      ),
                      // Center(
                      //   child: SizedBox(
                      //     // width: MediaQuery.of(context).size.width - 200,
                      //     height: 28,
                      //     child: FittedBox(
                      //       child: Text(
                      //           barcode?.barcodes.first.rawValue ??
                      //               'Ready to scan',
                      //           overflow: TextOverflow.fade,
                      //           style: const TextStyle(
                      //               fontSize: 12.0,
                      //               color: Color(0xFFE5E1E6)
                      //           )
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.cameraFacingState,
                          builder: (context, state, child) {
                            if (state == null) {
                              return const Icon(Icons.camera_front);
                            }
                            switch (state as CameraFacing) {
                              case CameraFacing.front:
                                return const Icon(Icons.camera_front);
                              case CameraFacing.back:
                                return const Icon(Icons.camera_rear);
                            }
                          },
                        ),
                        iconSize: 24.0,
                        onPressed: () => controller.switchCamera(),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.image),
                        iconSize: 24.0,
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            if (await controller.analyzeImage(image.path)) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Barcode found!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No barcode found!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                        iconSize: 24.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
