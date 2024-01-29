import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scan_school/screen/create_classroom.dart';
import 'package:scan_school/screen/liste_presence.dart';
import 'package:scan_school/screen/mes_rapports.dart';
import 'package:scan_school/screen/search_candidat.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'liste_absent.dart';

class ScanqrCode extends StatefulWidget {
  const ScanqrCode({Key? key}) : super(key: key);

  @override
  State<ScanqrCode> createState() => _ScanqrCodeState();
}

class _ScanqrCodeState extends State<ScanqrCode> {
  List jsonExamen = [
    {
      'id': 1,
      'name': 'BAC',
      'img': 'bac.png',
    },
    {
      'id': 2,
      'name': 'BET',
      'img': 'bet.jpg',
    },
    {
      'id': 3,
      'name': 'BEP',
      'img': 'bep.png',
    },
    {
      'id': 4,
      'name': 'BTF',
      'img': 'btf.png',
    },
    {
      'id': 5,
      'name': 'BT',
      'img': 'bt.png',
    },
    {
      'id': 6,
      'name': 'CAP',
      'img': 'cap.png',
    },
    {
      'id': 7,
      'name': 'Concours directs',
      'img': 'concour_direct.png',
    },
    {
      'id': 8,
      'name': 'Examens de sortie',
      'img': 'exam_sortie.jpg',
    },
    {
      'id': 9,
      'name': 'Cancours professionnels',
      'img': 'professionel.jpg',
    }
  ];
  String _data = "";
  int activeTab = 0;
  String salle = "";
  String examen = "";
  String total = "";
  String img = "";
  var jsonCandidat;
  var epreuve = 1;
  List<Map<String, dynamic>> _allPresence = [];

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));

    String jsonString = await rootBundle.loadString('lib/utils/bac2.json');
    // Convertir la chaîne JSON en une structure de données Dart
    List<dynamic> jsonData = json.decode(jsonString);
    var codeSearch = "TX75621029";
    var studentWithCode = jsonData.firstWhere(
      (student) => student['MATRICULE'] == _data,
      orElse: () => null,
    );
    addPresence(studentWithCode);

    setState(() {
      jsonCandidat = studentWithCode;
    });

    print('dataSearch:${studentWithCode}');
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }

  Future<void> addPresence(candidat) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scan.db');

    // open the database

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  Presence  (id INTEGER PRIMARY KEY AUTOINCREMENT, name_etablissement TEXT, '
          ' name_salle TEXT, total TEXT, type_examen TEXT , nom TEXT, prenom TEXT, code_eleve TEXT, epreuve TEXT, date TEXT, time TEXT)');
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var salle = prefs.getString('salleSession');

    if (candidat != null) {
      // Access 'MATRICULE' only if candidat is not null
      String matricule = candidat['MATRICULE'];
      List<Map<String, dynamic>> existingRecords = await database.query(
        'Presence',
        where: 'code_eleve = ? AND name_salle = ?',
        whereArgs: [candidat['MATRICULE'], salle],
      );


      if (existingRecords.isEmpty) {
        // If no record found, insert a new one
        var salle = prefs.getString('salleSession');
        var examen = prefs.getString('type_examen_session');
        var total = prefs.getString('total_candidat');
        var etab = prefs.getString('name_etablissement');
        var epreuve = '0';

        await database.insert('Presence', {
          'name_etablissement': etab,
          'name_salle': salle,
          'total': total,
          'type_examen': examen,
          'nom': candidat['NOM'],
          'prenom': candidat['PRENOM'],
          'code_eleve': candidat['MATRICULE'],
          'epreuve': epreuve,
          'date': _getCurrentDate(),
          'time': _getCurrentTime()
        });
        print('Presence inserted successfully.');
      } else {
        // If a record with the same name_salle exists, you can choose to update it or handle it accordingly.
        print('Presnce with name_salle already exists.');
      }
      // Proceed with your logic using matricule
    }



    _allPresence = await database.query('Presence');
    setState(() {
      _allPresence;
    });

    print(await database.query('Presence'));

    // print('student inserer');
    // Close the database connection
    await database.close();
  }

  Future<void> sessionInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      salle = prefs.getString('salleSession')!;
      examen = prefs.getString('type_examen_session')!;
      total = prefs.getString('total_candidat')!;
    });

    var studentWithCode = jsonExamen.firstWhere(
      (student) => student['name'] == examen,
      orElse: () => null,
    );

    setState(() {
      img = studentWithCode['img'];
    });

    print('dataSearch:${studentWithCode}');
  }

  //RECUPERATION DES SALLLE
  List _allSalle = [];

  Future<void> dataSallle() async {
    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    // await deleteDatabase(path);
    _allSalle = await database.query('Salle');
    setState(() {
      _allSalle;
    });
  }

  //recuper les infos d'une salle
  Future<void> getSalle(salles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);

    List<Map<String, dynamic>> salleData = await database.query(
      'Salle',
      where: 'name_salle = ? ',
      whereArgs: [salles],
    );

    prefs.setString(
        'type_examen_session', salleData[0]['type_examen'].toString());
    prefs.setString('total_candidat', salleData[0]['total']);
    prefs.setString('salleSession', salleData[0]['name_salle']);
    prefs.setString('name_etablissement', salleData[0]['name_etablissement']);

    print("salle: $salleData");

    setState(() {
      salle = prefs.getString('salleSession')!;
      examen = prefs.getString('type_examen_session')!;
      total = prefs.getString('total_candidat')!;
    });

    await database.close();
  }

  @override
  void initState() {
    sessionInit();
    super.initState();
    dataSallle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135),
        child: Column(
          children: [
            AppBar(
              leadingWidth: MediaQuery.of(context).size.width,
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
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
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Scan Candidat',
                          style: TextStyle(color: Colors.black,fontSize: 17),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        PopupMenuButton(
                            icon: const Icon(
                              Icons.apps,
                              color: Colors.black,
                            ),
                            // color: Color(0xFF391C4A),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text(
                                      'Liste des absents',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onTap: () {


                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .leftToRight,
                                              child: const listeAbsent()));
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text(
                                      'Mes rapports',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .leftToRight,
                                              child: const mesRapports()));
                                    },
                                  ),
                                ]),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchCandidat()));
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 23,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            menu()
          ],
        ),
      ),
      body:   getBodyMenu(),
    );
  }

  Widget menu() {
    return Container(
      width: MediaQuery.of(this.context).size.width / 1.5,
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
                      "Présence",
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
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                    Text('Scanner les candidats {${salle.toString()}}',style: const TextStyle(fontSize: 17),),
                  PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      // color: Color(0xFF391C4A),
                      itemBuilder: (context) =>
                          List.generate(_allSalle.length, (index) {
                            var salle = _allSalle[index];
                            return PopupMenuItem(
                              child: Text(
                                'SALLE ${salle['name_salle']}',
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                getSalle(salle['name_salle']);
                              },
                            );
                          })),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              _data == ''
                  ? Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(this.context).size.width / 1.5,
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
                            const SizedBox(
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
              GestureDetector(
                onTap: ()=>_scan(),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(6),


                  child:   const Padding(
                    padding:  EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                      child: Text('Scanner un candidat',style: TextStyle(fontSize: 16,color: ColorsApp.colorPurpe),)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              Text(_data),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    this.context,
                    MaterialPageRoute(
                        builder: (context) => createClassRoom(
                              img: img,
                              name: examen,
                            )));
              },
              child:   Material(
                elevation: 3,
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                child:   const Padding(
                    padding: EdgeInsets.all(13),
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: ColorsApp.colorPurpe,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget resultSan() {
    return Container(
      child: jsonCandidat == null
          ? Center(
              child: Column(
                children: [
               SizedBox(
                 width: MediaQuery.of(this.context).size.width/1.5,
                 height: MediaQuery.of(this.context).size.width/2.2,
                 child: Image.asset('asset/faux.jpeg',fit: BoxFit.cover,),
               ),
                  Text(
                    'Les informations du Qr code ne font pas partie de la liste des candidats',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          : Column(
              children: [

                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                      backgroundImage: AssetImage('asset/${jsonCandidat['MATRICULE']}.jpeg')

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      jsonCandidat['NOM'],
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      jsonCandidat['PRENOM'],
                      style: const TextStyle(fontSize: 22),
                    )
                  ],
                ),
                Text(
                 "Code: ${ jsonCandidat['MATRICULE']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15,),
                Text(
                 "Date naissance: ${ jsonCandidat['DATE NAISSANCE']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
    );
  }
}
