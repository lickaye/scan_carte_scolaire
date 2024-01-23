import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_school/screen/liste_presence.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanqrCode extends StatefulWidget {
  const ScanqrCode({Key? key}) : super(key: key);

  @override
  State<ScanqrCode> createState() => _ScanqrCodeState();
}

class _ScanqrCodeState extends State<ScanqrCode> {
  String _data = "";
  int activeTab = 0;
  String salle = "";
  String examen = "";
  String total = "";
  var jsonCandidat;

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));

    String jsonString = await rootBundle.loadString('lib/utils/bac.json');
    // Convertir la chaîne JSON en une structure de données Dart
    List<dynamic> jsonData = json.decode(jsonString);
    var codeSearch = "TX75621029";
    var studentWithCode = jsonData.firstWhere(
      (student) => student['code_eleve'] == _data,
      orElse: () => null,
    );
    setState(() {
      jsonCandidat = studentWithCode;
    });

    print('dataSearch:${studentWithCode}');
  }

  Future<void> sessionInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      salle = prefs.getString('salleSession')!;
      examen = prefs.getString('type_examen_session')!;
      total = prefs.getString('total_candidat')!;
    });
  }

  @override
  void initState() {
    sessionInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135),
        child: Column(
          children: [
            AppBar(
              leadingWidth: MediaQuery.of(context).size.width,
              automaticallyImplyLeading: true,
              backgroundColor: ColorsApp.colorPurpe,
              leading: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8, right: 8, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.keyboard_backspace_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Scan Candidat',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(
                      Icons.search,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            menu()
          ],
        ),
      ),
      body: getBodyMenu(),
    );
  }

  Widget menu() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black.withOpacity(0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                activeTab = 0;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: activeTab == 0
                        ? ColorsApp.colorPurpe
                        : Colors.transparent),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: activeTab == 0 ? 35 : 15,
                        right: activeTab == 0 ? 20 : 15,
                        top: 8,
                        bottom: 8),
                    child: Text("Scannage",
                        style: TextStyle(
                            fontSize: 16,
                            color: activeTab == 0
                                ? Colors.white
                                : Colors.black)))),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                activeTab = 1;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: activeTab == 1
                        ? ColorsApp.colorPurpe
                        : Colors.transparent),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: activeTab == 1 ? 35 : 15,
                        right: activeTab == 1 ? 20 : 15,
                        top: 8,
                        bottom: 8),
                    child: Text(
                      "Presence",
                      style: TextStyle(
                          fontSize: 16,
                          color: activeTab == 1 ? Colors.white : Colors.black),
                    ))),
          ),
        ],
      ),
    );
  }

  Widget getBodyMenu() {
    return IndexedStack(
      index: activeTab,
      children: [bodyScaner(), const ListePresence()],
    );
  }

  Widget bodyScaner() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          _data == ''
              ? Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Image.asset(
                        'asset/scan.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SALLE: $salle'),
                       const  SizedBox(
                          width: 11,
                        ),
                        Text('CANDIDAT: $total'),
                      ],
                    ),

                    Text('EXAMEN: $examen'),
                  ],
                )
              : resultSan(),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () => _scan(),
              child: const Text(
                'Scaner un  candidat',
                style: TextStyle(color: ColorsApp.colorPurpe, fontSize: 16),
              )),
          Text(_data)
        ],
      ),
    );
  }

  Widget resultSan() {
    return Container(
      child: jsonCandidat == null
          ? Center(
            child: Text(
                'Les informations du Qr code ne fait pas partie de la liste des candidats'),
          )
          : Column(
        
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(

                    child: Image.asset('asset/scan.png',fit: BoxFit.cover,),
                  ),
                ),
                Text(jsonCandidat['nom'],style: const TextStyle(fontSize: 20),),
                Text(jsonCandidat['prenom'],style: const TextStyle(fontSize: 15),)
              ],
            ),
    );
  }
}
