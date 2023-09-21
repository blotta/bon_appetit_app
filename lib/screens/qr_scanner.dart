import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key, required this.onScanningDone});

  final Function(String) onScanningDone;

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

// TODO: add iOS (info.plist) support for qr_code_scanner package
class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? lastSearchedRestaurant;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            QRView(
                key: qrKey,
                formatsAllowed: const [BarcodeFormat.qrcode],
                overlay: QrScannerOverlayShape(
                    borderColor: Theme.of(context).colorScheme.surface,
                    borderRadius: 10,
                    borderWidth: 8,
                    cutOutSize: MediaQuery.of(context).size.width * 0.7),
                onQRViewCreated: (QRViewController ctrl) {
                  controller = ctrl;
                  bool scanned = false;
                  ctrl.scannedDataStream.listen((scanData) {
                    ctrl.pauseCamera();
                    if (!scanned && scanData.code != null) {
                      scanned = true;
                      widget.onScanningDone(scanData.code!);
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
