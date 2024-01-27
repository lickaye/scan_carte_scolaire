import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'detail_search.dart';

class SearchCandidat extends StatefulWidget {
  const SearchCandidat({super.key});

  @override
  State<SearchCandidat> createState() => _SearchCandidatState();
}

class _SearchCandidatState extends State<SearchCandidat> {
  final searchController = TextEditingController();

  List _allCandidat = [];

  List _foundUsers=[];

  Future<void> candidatStudent() async {
    String jsonString = await rootBundle.loadString('lib/utils/bac.json');
    // Convertir la chaîne JSON en une structure de données Dart
    List<dynamic> jsonData = json.decode(jsonString);


    setState(() {
      _allCandidat = jsonData;
      _foundUsers = _allCandidat;
    });
  }

  void _runFilter(String enterKey) async{
    List result = [];

    if(enterKey.isEmpty){
      result = _allCandidat;
    }else{
      result = _allCandidat.where((element)=>element['code_eleve'].toLowerCase().contains(enterKey.toLowerCase())).toList();
    }

    setState(() {
      _foundUsers = result;
    });

  }

  @override
  void initState() {
    candidatStudent();
    super.initState();
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 1,
      backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: const Icon(Icons.arrow_back_ios)),
        iconTheme: IconThemeData(
          color: Colors.black, // Changer la couleur de la flèche ici
        ),
        title: Container(


          child: TextFormField(

            controller: searchController,
            cursorColor: Colors.black,
            onChanged: (value) =>_runFilter(value),
            onEditingComplete: () {
              // L'événement onEditingComplete est déclenché lorsque l'édition est terminée (curseur hors focus).
              // handleElementRecovery();
            },
            inputFormatters: [UpperCaseTextFormatter()],
            keyboardType: TextInputType.text,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              contentPadding: EdgeInsets.all(
                  MediaQuery.of(context).size.width / 38),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              /* suffixIcon: Icon(
                          Icons.search,
                          color: Colors.blue,
                          size: 17,
                        ),*/

              prefix: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 1,
                //height: 20,
              ),

              //fillColor: Colors.white,
              hintText: "Entrer le code du candidat ",
              hintStyle: const TextStyle(
                fontSize: 17.0,
                color: Colors.grey
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: _foundUsers.length,
          itemBuilder: (context,index) {
          var candidat = _foundUsers[index];
          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType
                          .fade,
                      child:   detailSearch(candidat: candidat,)));
            },
            child: Container(
              margin:const EdgeInsets.only(right: 20,left: 20),
              color: Colors.white,
              child: Card(
                color: Colors.white,

                key: ValueKey(_foundUsers[index]['id']),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Text(candidat['id'].toString()),
                  title: Row(
                  children: [
                  Text(candidat['nom'].toString(),),
                   const  SizedBox(width: 10,),
                    Text(candidat['prenom'].toString(),)
                  ],
                  ),
                  subtitle: Text(candidat['code_eleve'].toString(),),


                )),
            ),
          );
          }),
    );
  }


}



class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text!.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

