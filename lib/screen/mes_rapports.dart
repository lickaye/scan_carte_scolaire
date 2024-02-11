
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/colors_app.dart';


class mesRapports extends StatefulWidget {
  const mesRapports({super.key});

  @override
  State<mesRapports> createState() => _mesRapportsState();
}

class _mesRapportsState extends State<mesRapports> with SingleTickerProviderStateMixin{


  late TabController _tabController2;
  int activeTab = 0;
  List _allSalle=[];
  List _allCandidat = [];
  List _allCandidatAbsent = [];

  List<List<dynamic>> data = [];



  Future<void> moveFileToPublicDirectory(String currentFilePath,type) async {


    try {
      // Obtenez le répertoire de téléchargement public
      Directory publicDirectory = Directory('/storage/emulated/0/Download');
      String publicPath = publicDirectory.path;

      // Renommer le nouveau fichier
      String newFileName = 'liste$type.${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String newFilePath = '$publicPath/$newFileName';
      // Vérifier si le fichier de destination existe déjà
      bool destinationExists = await File(newFilePath).exists();
      if (destinationExists) {
        // Si le fichier de destination existe déjà, supprimez-le d'abord
        await File(newFilePath).delete();
      }



      await File(currentFilePath).copy(newFilePath);


      print('Le fichier a été déplacé avec succès vers $newFilePath');
    } catch (e) {
      print('Une erreur s\'est produite lors du déplacement du fichier : $e');
    }
  }

  String? mapListToCsv(List<Map<String, Object?>>? mapList, {ListToCsvConverter? converter}) {
    if (mapList == null) {
      return null;
    }

    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    int addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      var dataRow = List<Object?>.filled(keyIndexMap.length, null);
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          keyIndex = addKey(key);
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }




  Future<void> getPresenceFromSalle(salles) async{

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);


    List<Map<String, dynamic>> presenceData = await database.query(
      'Presence',
      where: 'name_salle = ? ',
      whereArgs: [salles],
    );

    setState(() {
      _allCandidat = presenceData;
    });

print(_allCandidat);
   // createExcel(_allCandidat);
    await database.close();
  }

  Future<void> dataCentre() async {
    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    // await deleteDatabase(path);
    _allSalle = await database.query('Salle');
    setState(() {
      _allSalle;
    });
  }

  Future<void> createExcel(data,type) async {
    // Créer un nouveau document Excel
    var excel = Excel.createExcel();

    // Ajouter une feuille au document Excel
    var sheet = excel['Sheet1'];

    // Ajouter des en-têtes
    sheet.appendRow([
      'ID    ',
      'Établissement                      ',
      'Salle                              ',
      'Total                              ',
      'Type Examen                        ',
      'Nom                                ',
      'Prénom                             ',
      'Code Élève                         ',
      'Date                               ',
      'Heure                              '
    ]);

    // Définir la largeur des colonnes

    sheet.setColAutoFit(0);
    sheet.setColAutoFit(1);
    sheet.setColAutoFit(2);
    sheet.setColAutoFit(3);
    sheet.setColAutoFit(4);
    sheet.setColAutoFit(5);
    sheet.setColAutoFit(6);
    sheet.setColAutoFit(7);
    sheet.setColAutoFit(8);
    sheet.setColAutoFit(9);
    sheet.setColAutoFit(10);
    sheet.setColAutoFit(11);

    // Ajouter les données
    for (var item in data) {
      sheet.appendRow([
        item['id'],
        item['name_etablissement'],
        item['name_salle'],
        item['total'],
        item['type_examen'],
        item['nom'],
        item['prenom'],
        item['code_eleve'],
        item['date'],
        item['time'],
      ]);
    }

    // Obtenir le répertoire d'enregistrement local
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;

    // Enregistrer le fichier Excel
    var file = '$appDocumentsPath/exam_data.xlsx';
    var excelBytes = excel.encode();
    if (excelBytes != null) {
      await File(file).writeAsBytes(excelBytes);
      print('Le fichier a été enregistré $file');
      moveFileToPublicDirectory(file,type);
    } else {
      print('Erreur lors de la création du fichier Excel.');
    }
  }
  Future<void> createExcelAbsent(data,type) async {
    // Créer un nouveau document Excel
    var excel = Excel.createExcel();

    // Ajouter une feuille au document Excel
    var sheet = excel['Sheet1'];

    // Ajouter des en-têtes
    sheet.appendRow([
      'ID    ',
      'Établissement                      ',
      'Salle                              ',
      'Total                              ',
      'Type Examen                        ',
      'Nom                                ',
      'Prénom                             ',
      'Code Élève                         ',
      'Épreuve                            ',
      'Date                               ',
      'Heure                              '
    ]);

    // Définir la largeur des colonnes

    sheet.setColAutoFit(0);
    sheet.setColAutoFit(1);
    sheet.setColAutoFit(2);
    sheet.setColAutoFit(3);
    sheet.setColAutoFit(4);
    sheet.setColAutoFit(5);
    sheet.setColAutoFit(6);
    sheet.setColAutoFit(7);
    sheet.setColAutoFit(8);
    sheet.setColAutoFit(9);
    sheet.setColAutoFit(10);
    sheet.setColAutoFit(11);

    // Ajouter les données
    for (var item in data) {
      sheet.appendRow([
        item['id'],
        item['name_etablissement'],
        item['name_salle'],
        item['total'],
        item['type_examen'],
        item['nom'],
        item['prenom'],
        item['code_eleve'],
        item['epreuve'],
        item['date'],
        item['time'],
      ]);
    }

    // Obtenir le répertoire d'enregistrement local
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;

    // Enregistrer le fichier Excel
    var file = '$appDocumentsPath/exam_data.xlsx';
    var excelBytes = excel.encode();
    if (excelBytes != null) {
      await File(file).writeAsBytes(excelBytes);
      print('Le fichier a été enregistré $file');
      moveFileToPublicDirectory(file,type);
    } else {
      print('Erreur lors de la création du fichier Excel.');
    }
  }

  Future<void> dataStudent() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var salle = prefs.getString('salleSession');

    List<Map<String, dynamic>> presenceData = await database.query(
      'Presence',
      where: 'name_salle = ? ',
      whereArgs: [salle],
    );

    setState(() {
      _allCandidat = presenceData;
    });
  }


  //RECUPEATION DES CANDIDAT ABSENT
  Future<void> getAbsence() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    // await deleteDatabase(path);
    _allCandidatAbsent = await database.query('Absence');
    setState(() {
      _allCandidatAbsent;
    });
  }
  Future<void> getAbsenceFromSalle(salles) async{

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);


    List<Map<String, dynamic>> absenceData = await database.query(
      'Absence',
      where: 'name_salle = ? ',
      whereArgs: [salles],
    );

    setState(() {
      _allCandidatAbsent = absenceData;
    });

    await database.close();
  }


  @override
  void initState() {
    dataStudent();
    dataCentre();
    getAbsence();
    super.initState();
    _tabController2 = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
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
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Mes rapports',
                          style: TextStyle(color: Colors.black,fontSize: 22),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),

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
                                  'SALLE ${salle['name_salle']} [${salle['name_etablissement']}]',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  getPresenceFromSalle(salle['name_salle']);
                                  getAbsenceFromSalle(salle['name_salle']);
                                },
                              );
                            })),

                  ],
                ),
              ),
            ),
            menuslide()
          ],
        ),
      ),


      body: getBodyMenuModule(),



    );
  }

  Widget menuslide() {
    Widget child;
    child = SizedBox(
      height: 55,
      child: TabBar(
        controller: _tabController2,
        unselectedLabelColor: Colors.black,
        labelColor: ColorsApp.colorPurpe,
        labelStyle: const TextStyle(

            fontSize: 14.3,
            fontWeight: FontWeight.w500),
        indicatorColor: ColorsApp.colorPurpe,
        //indicator: ColorsApp.blue,
        onTap: (value) {
          setState(() {

            if (value == 0) {

            }
            if (value == 1) {

            }


          });
          print('valeur :$value');
        },

        tabs: const [
          Tab(
            text: 'Liste de presence',
          ),
          Tab(
            text: 'Les absents',
          ),

        ],
      ),
    );
    return Container(child: child);
  }

  Widget getBodyMenuModule() {
    return IndexedStack(
      index: _tabController2.index,
      children: [
        getPresenceListe(),
        getListeAbsent()
      ],
    );
  }

  Widget getPresenceListe() {
    return _allCandidat.isEmpty ? const Center(child: Text('Aucun élément pour le moment')):   Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [


        GestureDetector(
          onTap: () =>    createExcel(_allCandidat,'presence'),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  'Télécharger le rapport CSV',
                  style: TextStyle(
                      fontSize: 16, color: ColorsApp.colorPurpe),
                )),
          ),
        ),

          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name Etablissement')),
                  DataColumn(label: Text('Name Salle')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Type Examen')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Prenom')),
                  DataColumn(label: Text('Code Eleve')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                ],
                rows: _allCandidat
                    .map(
                      (item) => DataRow(cells: [
                    DataCell(Text(item['id'].toString())),
                    DataCell(Text(item['name_etablissement'].toString())),
                    DataCell(Text(item['name_salle'].toString())),
                    DataCell(Text(item['total'].toString())),
                    DataCell(Text(item['type_examen'].toString())),
                    DataCell(Text(item['nom'])),
                    DataCell(Text(item['prenom'])),
                    DataCell(Text(item['code_eleve'].toString())),
                    DataCell(Text(item['date'].toString())),
                    DataCell(Text(item['time'].toString())),
                  ]),
                )
                    .toList(),
              ),
            ),
          ),

      ],
    );
  }

  Widget getListeAbsent() {
    return  _allCandidatAbsent.isEmpty ? const Center(child:   Text('Aucun élément pour le moment')): Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //getBodyMenuModule(),


        GestureDetector(
          onTap: () =>  createExcelAbsent(_allCandidatAbsent,'absent'),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  'Télécharger le rapport CSV',
                  style: TextStyle(
                      fontSize: 16, color: ColorsApp.colorPurpe),
                )),
          ),
        ),

        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name Etablissement')),
                DataColumn(label: Text('Name Salle')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Type Examen')),
                DataColumn(label: Text('Nom')),
                DataColumn(label: Text('Prenom')),
                DataColumn(label: Text('Code Eleve')),
                DataColumn(label: Text('Epreuve')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Time')),
              ],
              rows: _allCandidatAbsent
                  .map(
                    (item) => DataRow(cells: [
                  DataCell(Text(item['id'].toString())),
                  DataCell(Text(item['name_etablissement'].toString())),
                  DataCell(Text(item['name_salle'].toString())),
                  DataCell(Text(item['total'].toString())),
                  DataCell(Text(item['type_examen'].toString())),
                  DataCell(Text(item['nom'])),
                  DataCell(Text(item['prenom'])),
                  DataCell(Text(item['code_eleve'].toString())),
                  DataCell(Text(item['epreuve'].toString())),
                  DataCell(Text(item['date'].toString())),
                  DataCell(Text(item['time'].toString())),
                ]),
              )
                  .toList(),
            ),
          ),
        ),

      ],
    );
  }
}
