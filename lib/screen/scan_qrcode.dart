import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanqrCode extends StatefulWidget {
  const ScanqrCode({Key? key}) : super(key: key);

  @override
  State<ScanqrCode> createState() => _ScanqrCodeState();
}

class _ScanqrCodeState extends State<ScanqrCode> {
  String _data = "";

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.BARCODE).then((value) => setState(() => _data = value));

    String jsonString = await rootBundle.loadString('lib/utils/bac.json');
    // Convertir la chaîne JSON en une structure de données Dart
    List<dynamic> jsonData = json.decode(jsonString);
    var codeSearch = "TX75621029";
    var studentWithCode = jsonData.firstWhere(
          (student) => student['code_eleve'] == _data,
      orElse: () => null,
    );

    print('dataSearch:${studentWithCode}');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () => _scan(), child: Text('Scanar code')),
          Text(_data)
        ],
      ),
    );
  }
}
