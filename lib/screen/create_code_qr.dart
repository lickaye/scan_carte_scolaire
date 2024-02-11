import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
class GenerateQrCode extends StatefulWidget {
  const GenerateQrCode({Key? key}) : super(key: key);

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrettyQr(

          size: 300,
          data: 'BGAB230045',
          errorCorrectLevel: QrErrorCorrectLevel.M,
          typeNumber: null,
          roundEdges: true,
        ),
      ),
    );
  }
}
