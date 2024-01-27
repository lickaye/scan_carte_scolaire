
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



import 'package:scan_school/utils/colors_app.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class mesRapports extends StatefulWidget {
  const mesRapports({super.key});

  @override
  State<mesRapports> createState() => _mesRapportsState();
}

class _mesRapportsState extends State<mesRapports> {




  Future<void> convert() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);

    try {
      var result = await database.query('Salle');
      var csv = mapListToCsv(result);

      if (csv != null) {
        await saveCsvFileToDownloads(csv);
      }
    } catch (e) {
      print('Erreur lors de la conversion ou de l\'enregistrement du fichier CSV : $e');
    } finally {
      await database.close();
    }
  }

  Future<void> saveCsvFileToDownloads(String csv) async {
    try {

      final directory = await getApplicationDocumentsDirectory(); // Obtenir le dossier des documents de l'application
      final path = directory.path + '/excel.csv';


      File file = File(path);
      await file.writeAsString(csv);


      print('Fichier CSV enregistré avec succès à la racine du stockage externe : $path');
    } catch (e) {
      print('Erreur lors de l\'enregistrement du fichier CSV : $e');
    }
  }


  String? mapListToCsv(List<Map<String, Object?>>? mapList,
      {ListToCsvConverter? converter}) {
    if (mapList == null) {
      return null;
    }

    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
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
      // This list might grow if a new key is found
      var dataRow = List<Object?>.filled(keyIndexMap.length, null);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }



// ...

  Future<void> saveCsvFile(String csv) async {
    try {
      //final String dir = (await getExternalStorageDirectory())!.path;
      final String path = '/storage/emulated/0/scan_data.csv';  // Chemin absolu vers la racine du stockage externe

      //final String path = '$dir/scan_data.csv';

      File file = File(path);
      await file.writeAsString(csv);

      print('Fichier CSV enregistré avec succès à : $path');
    } catch (e) {
      print('Erreur lors de l\'enregistrement du fichier CSV : $e');
    }
  }

// ...







  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135),
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

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
     body: Center(child: const Text('Aucun élément pour le moment')),
     /* body: GestureDetector(
        onTap: (){
          convert();
        },
        child: Text("click here"),
      ),*/
    );
  }
}
