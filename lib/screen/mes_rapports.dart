
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
        await saveCsvFile(csv);
      }
    } catch (e) {
      print('Erreur lors de la conversion ou de l\'enregistrement du fichier CSV : $e');
    } finally {
      await database.close();
    }
  }

  Future<void> saveCsvFile(String csv) async {

    try {
      // Obtenir le dossier racine du stockage externe
      final directory = await getApplicationDocumentsDirectory();

      // Créer le dossier `scan_school` si nécessaire
      if (!await directory!.exists()) {
        await directory?.create(recursive: true);
      }

      // Obtenir le chemin du fichier CSV
      final path = directory.path + '/excel.csv';

      // Créer le fichier CSV
      File file = File(path);

      // Écrire le contenu du fichier CSV
      await file.writeAsString(csv);

      // Afficher un message de confirmation
      print('Fichier CSV enregistré avec succès : $path');

    } catch (e) {
      // Afficher un message d'erreur
      print('Erreur lors de l\'enregistrement du fichier CSV : $e');
    }
  }


  Future<void> moveFile() async {
    // Obtenir le chemin du dossier de l'application
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Spécifier le chemin du fichier dans le dossier de l'application
    String filePathInApp = '$appDocPath/app_flutter/your_file_name.txt';

    // Spécifier le chemin du dossier public (par exemple, le dossier des images)
    String publicFolderPath = '/storage/emulated/0/Download';

    try {
      // Vérifier si le fichier existe
      if (await File(filePathInApp).exists()) {
        // Déplacer le fichier vers le dossier public
        File(filePathInApp).copy('$publicFolderPath/your_file_name.txt');
        print('Fichier déplacé avec succès.');
      } else {
        print('Le fichier n\'existe pas.');
      }
    } catch (e) {
      print('Erreur lors du déplacement du fichier : $e');
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
     //body: Center(child: const Text('Aucun élément pour le moment')),
      body: GestureDetector(
        onTap: (){
          convert();
        },
        child: Text("click here"),
      ),
    );
  }
}
