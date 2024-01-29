import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:convert';

import 'package:scan_school/screen/scren_config.dart';


class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  var data = [];

  Future<void> fetchData() async {
    String jsonString = await rootBundle.loadString('lib/utils/bac.json');
    // Convertir la chaîne JSON en une structure de données Dart
    List<dynamic> jsonData = json.decode(jsonString);
    var codeSearch = "TX75621029";
    var studentWithCode = jsonData.firstWhere(
      (student) => student['code_eleve'] == codeSearch,
      orElse: () => null,
    );

    print('dataSearch:${studentWithCode}');
    setState(() {
      data = jsonData;
    });

    print("data ${data.length}");
  }

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
   /* {
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
    }*/
  ];

  Future<void> sqliteCreate() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scan.db');

    // open the database

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Salle  (id INTEGER PRIMARY KEY AUTOINCREMENT, name_etablissement TEXT,  name_salle TEXT, total TEXT, type_examen TEXT)');

      await db.execute(
          'CREATE TABLE Presence  (id INTEGER PRIMARY KEY AUTOINCREMENT, name_etablissement TEXT, '
          ' name_salle TEXT, total TEXT, type_examen TEXT , nom TEXT, prenom TEXT, code_eleve TEXT, epreuve TEXT, date TEXT, time TEXT)');
      await db.execute(
          'CREATE TABLE  Absence  (id INTEGER PRIMARY KEY AUTOINCREMENT, name_etablissement TEXT, '
          ' name_salle TEXT, total TEXT, type_examen TEXT , nom TEXT, prenom TEXT, code_eleve TEXT, epreuve TEXT, motif TEXT, date TEXT, time TEXT)');
    });

    await database.close();
  }



  @override
  initState() {
    sqliteCreate();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /* body: Stack(
        children: [
          Stack(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(

                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    height: MediaQuery.of(context).size.height,
                    enableInfiniteScroll: 3 == 1 ? false : true,
                    autoPlay: 3 == 1 ? false : true),
                itemCount: jsonExamen.length,
                itemBuilder: (context, index, realIndex) {
                  var examen = jsonExamen[index];
                  var img = examen['img'];
                  var name = examen['name'];

                  return Container(
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                            spreadRadius: 0.5,  // L'écart de diffusion de l'ombre
                            blurRadius: 0.3,    // Le rayon de flou de l'ombre
                            offset: Offset(0, 0.5), // L'offset de l'ombre par rapport à la boîte
                          ),
                        ],
                        image:   DecorationImage(
                          image:   AssetImage('asset/$img'),
                          fit: BoxFit.fitHeight,
                        )

                    ),
                  );
                },
              ),
              Expanded(child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.3),

                ),
              ))
            ],
          ),
        Expanded(child:   getBody())
        ],
      ),*/
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150,
        ),
        const Center(
          child: Text(
            "Ministère de l'enseignemt technique et professionnel",
            style: TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              height: 220,
              enableInfiniteScroll: 3 == 1 ? false : true,
              autoPlay: 3 == 1 ? false : true),
          itemCount: jsonExamen.length,
          itemBuilder: (context, index, realIndex) {
            var examen = jsonExamen[index];
            var img = examen['img'];
            var name = examen['name'];

            return GestureDetector(
              onTap: () {
                name == 'BAC'
                    ? Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: ScreenConfig(
                              img: img,
                              name: name,
                            )))
                    : showModalBottomSheet(

                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                20.0), // Ajustez le rayon pour arrondir les coins
                          ),
                        ),

                        builder: (BuildContext context) {
                          return   Container(
                            margin: const EdgeInsets.only(left: 15,right: 15),

                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.swipe_up,size: 35,color: Colors.red,),
                               const  Text(
                                  "Oups! le scan candidat de cet examen n'est pas disponible pour le moment.Sélectionnez le BAC",
                                  style: TextStyle(fontSize: 17,color: Colors.black),
                                ),

                              ],
                            ),
                          );
                        },
                      );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        // Couleur de l'ombre
                        spreadRadius: 0.5,
                        // L'écart de diffusion de l'ombre
                        blurRadius: 1,
                        // Le rayon de flou de l'ombre
                        offset: Offset(0,
                            0.5), // L'offset de l'ombre par rapport à la boîte
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('asset/$img'),
                      fit: BoxFit.cover,
                    )),
              ),
            );
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: SizedBox(
                    height: 85,
                    child: Image.asset('asset/armoirie.png'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
