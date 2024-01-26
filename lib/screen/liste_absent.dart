import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../utils/colors_app.dart';

class listeAbsent extends StatefulWidget {
  const listeAbsent({super.key});

  @override
  State<listeAbsent> createState() => _listeAbsentState();
}

class _listeAbsentState extends State<listeAbsent> {
  List _allCandidat = [];
  List _allSalle = [];

  //RECUPEATION DES CANDIDAT SCANNER
  Future<void> dataStudent() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    // await deleteDatabase(path);
    _allCandidat = await database.query('Absence');
    setState(() {
      _allCandidat;
    });
  }

  //RECUPERATION DES SALLLE

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

  Future<void> getAbsenceFromSalle(salles) async{

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);


    List<Map<String, dynamic>> absenceData = await database.query(
      'Absence',
      where: 'name_salle = ? ',
      whereArgs: [salles],
    );

    setState(() {
      _allCandidat = absenceData;
    });

    await database.close();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataStudent();
    dataSallle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },

            child: const Icon(Icons.keyboard_backspace,color: Colors.black,)),
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Liste des absents',style: TextStyle(fontSize: 17,color: Colors.black),),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert,color: Colors.black,),
                // color: Color(0xFF391C4A),
                itemBuilder: (context) => List.generate(_allSalle.length,(index){
                  var salle = _allSalle[index];
                  return  PopupMenuItem(
                    child: Text(
                      'SALLE ${salle['name_salle']}',
                      style: TextStyle(
                          fontSize: 12),
                    ),
                    onTap: () {
                      getAbsenceFromSalle(salle['name_salle']);
                    },
                  );
                })),
          ],
        ),

      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
          child: getBody()),
    );
  }

  Widget getBody(){
    return ListView.builder(
        itemCount: _allCandidat.length,
        itemBuilder: (context,index) {
          var candidat = _allCandidat[index];
          return Container(
            margin:const EdgeInsets.only(right: 20,left: 20),
            child: Card(
                key: ValueKey(_allCandidat[index]['id']),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Text(candidat['id'].toString()),
                  title: Row(
                    children: [
                      Text(candidat['nom'].toString(),),
                      const SizedBox(width: 10,),
                      Text(candidat['prenom'].toString(),)
                    ],
                  ),
                  subtitle: Text(candidat['code_eleve'].toString(),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Set to MainAxisSize.min to allow the Row to occupy minimum space
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: ColorsApp.colorPurpe),
                        ),
                        padding: const EdgeInsets.all(8), // Adjust padding as needed
                        child: Icon(Icons.check, color: ColorsApp.colorPurpe),
                      ),
                      const SizedBox(
                        width: 8,
                      ),

                    ],
                  ),
                )
            ),
          );
        });
  }




}
