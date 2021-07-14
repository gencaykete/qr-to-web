import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_to_web/result.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final QrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  bool isErrorUrl = false;

  @override
  void disponse() {
    controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        buildQrView(context),
        Visibility(
          visible: isErrorUrl,
          child: Positioned(
              bottom: 10,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white24),
                child: Text(
                  "Error Url",
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                ),
              )),
        )
      ],
    ));
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: QrKey,
        onQRViewCreated: QrViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 10,
            borderRadius: 10,
            borderLength: 15,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );

  void QrViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcode = scanData;
      });
      controller.pauseCamera();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScannerResult(barcode!)))
          .then((value) => controller.resumeCamera());

      /*if (Uri.parse(barcode!.code).isAbsolute) {
        this.isErrorUrl = false;
        controller.pauseCamera();
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScannerResult(barcode!)))
            .then((value) => controller.resumeCamera());
      } else {
        setState(() {
          this.isErrorUrl = true;
        });
      }*/
    });
  }
}
