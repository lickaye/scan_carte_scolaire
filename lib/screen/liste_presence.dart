import 'package:flutter/material.dart';
import 'package:scan_school/utils/colors_app.dart';

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
              //backgroundColor: ColorsApp.colorPurpe,
              leading:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Liste de presence'),
                  PopupMenuButton(
                      icon: const Icon(Icons.more_vert,color: Colors.black,),
                      // color: Color(0xFF391C4A),
                      itemBuilder: (context) => List.generate(jsonExamen.length,(index){
                        var exam = jsonExamen[index];
                        return  PopupMenuItem(
                          child: Text(
                            '${exam['name']}',
                            style: TextStyle(
                                fontSize: 12),
                          ),
                          onTap: () {

                          },
                        );
                      })),
                ],
              ),
            ),

            menu()
          ],
        ),
        )
    );
  }

  Widget menu(){
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(menuList.length, (index){
          var menu = menuList[index];
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Container(

              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:  ColorsApp.colorPurpe,
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
}
