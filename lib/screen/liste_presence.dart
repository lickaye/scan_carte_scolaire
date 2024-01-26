import 'package:flutter/material.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'absence.dart';

class ListePresence extends StatefulWidget {
  const ListePresence({super.key});

  @override
  State<ListePresence> createState() => _ListePresenceState();
}

class _ListePresenceState extends State<ListePresence> {
  List jsonExamen = [
    {
      'id':1,
      'name':'BAC',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    },
    {
      'id':2,
      'name':'BET',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    },
    {
      'id':3,
      'name':'BEP',
      'img':'https://lesechos-congobrazza.com/images/2019/CORNIV.jpg',
    },
    {
      'id':4,
      'name':'BTF',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    },
    {
      'id':5,
      'name':'BT',
      'img':'https://i.ytimg.com/vi/_MJ5ZAzKGBo/maxresdefault.jpg',
    },
    {
      'id':6,
      'name':'CAP',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    },
    {
      'id':7,
      'name':'Concours directs',
      'img':'https://www.unicondevelopment.com/wp-content/uploads/brazzaville_congo_unicon_project_03.jpg',
    },
    {
      'id':8,
      'name':'Examens de sortie',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    },
    {
      'id':9,
      'name':'Cancours professionnels',
      'img':'https://www.shutterstock.com/image-photo/city-brazzaville-congo-africa-daytime-600nw-2262418221.jpg',
    }
  ];
  List menuList = [
    {'name': 'Lundi', 'id': 0},
    {'name': 'Mardi', 'id': 1},
    {'name': 'Mercredi', 'id': 2},
    {'name': 'Jeudi', 'id': 3},
    {'name': 'Vendredi', 'id': 4},
    {'name': 'Samedi', 'id': 5},
    {'name': 'Dimanche', 'id': 6},
  ];
  int activeTab = 1;
  List _allCandidat = [];
  List _allSalle = [];

  //RECUPEATION DES CANDIDAT SCANNER
  Future<void> dataStudent() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
    // await deleteDatabase(path);
    _allCandidat = await database.query('Presence');
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
      backgroundColor: Colors.white,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Liste de présence',style: TextStyle(fontSize: 16),),
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
                        getPresenceFromSalle(salle['name_salle']);
                      },
                    );
                  })),
            ],
          ),
        ),
      body: getBody(),
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
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder:
                                      (context) =>
                                        Absence(candidat: candidat,)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: ColorsApp.colorPurpe),
                          ),
                          padding: const EdgeInsets.all(8), // Adjust padding as needed
                          child: const Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        });
  }

  Widget menu(){
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(menuList.length, (index){
          var menu = menuList[index];
          return Padding(
            padding: const EdgeInsets.all(13),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  activeTab = menu['id'];
                });
              },

              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: activeTab == menu['id'] ?  ColorsApp.colorPurpe:Colors.transparent,
                          // Couleur de la barre noire
                          width: 3, // Épaisseur de la barre
                        ),
                      ),
                    ),
                    child: Text('${menu['name']}',style: const TextStyle(fontSize: 15),

                    ),
                  ),

                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getBodyMenu() {
    return IndexedStack(
      index: activeTab,
      children: List.generate(menuList.length, (index){
        var content = menuList[index];
        return Text('${content['name']}');
      }),
    );
  }
}
