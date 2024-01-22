import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'dart:convert';

import 'package:scan_school/screen/create_classroom.dart';



class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {

  var data=[];
  Future<void> fetchData() async{
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



  @override
  initState()   {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(

      body: getBody(),
    );
  }


  Widget getBody(){
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
          Center(
            child: SizedBox(
              height: 85,
              child: Image.asset('asset/logo_dark.png'),
            ),
          ),
        const SizedBox(
          height: 150,
        ),
       Container(
         margin: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
        // width: MediaQuery.of(context).size.width,
           child: const  Text('Type examen',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22),)),
       const  SizedBox(
          height: 10,
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
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context) =>
                            createClassRoom(img: img,name: name,)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                        spreadRadius: 0.5,  // L'écart de diffusion de l'ombre
                        blurRadius: 0.3,    // Le rayon de flou de l'ombre
                        offset: Offset(0, 0.5), // L'offset de l'ombre par rapport à la boîte
                      ),
                    ],
                    image:   DecorationImage(
                        image: NetworkImage(img),
                      fit: BoxFit.cover,
                    )

                ),
              ),
            );
          },
        ),

        const Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Republique du congo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Text('Unite * Travail * Progres',style: TextStyle(fontSize: 11),),
              ],
            ),
          ),
        )

      ],
    );
  }


}
