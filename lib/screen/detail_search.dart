import 'package:flutter/material.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class detailSearch extends StatefulWidget {
  final Map<String, dynamic> candidat;
    detailSearch({super.key,required this.candidat});

  @override
  State<detailSearch> createState() =>   _detailSearchState(candidat:candidat);
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

class _detailSearchState extends State<detailSearch> {


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





    print(await database.query('Presence'));

    // print('student inserer');
    // Close the database connection
    await database.close();
  }

  final Map<String, dynamic> candidat;
  _detailSearchState({required this.candidat});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        iconTheme: const IconThemeData(
          color: Colors.black, // Changer la couleur de la flèche ici
        ),
        title: const Text('Detail',style: TextStyle(fontSize: 17,color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        const SizedBox(height: 25,),
              SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                  backgroundImage: const AssetImage('asset/TX28994208.jpeg')

              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width/1,
                child: Text("${candidat['NOM']} ${candidat['PRENOM']}",maxLines: 2,style: const TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
              ),
            ),
            Text(
              "Code: ${ candidat['MATRICULE']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15,),
            Text(
              "Date naissance: ${ candidat['DATE NAISSANCE']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25,),
            GestureDetector(

              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(6),


                child:     Padding(
                    padding:  const EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 10),
                    child: GestureDetector(
                      onTap: (){
                        addPresence(candidat);
                      },
                        child: const Text('Valider',style: TextStyle(fontSize: 16,color: ColorsApp.colorPurpe),))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
