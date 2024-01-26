import 'package:flutter/material.dart';
import 'package:scan_school/screen/scan_qrcode.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Absence extends StatefulWidget {
  final Map<String, dynamic> candidat;
    Absence({super.key,required this.candidat});

  @override
  State<Absence> createState() => _AbsenceState(candidat:candidat);
}

class _AbsenceState extends State<Absence> {
  final Map<String, dynamic> candidat;
  _AbsenceState({required this.candidat});
  final formkey = new GlobalKey<FormState>();
  final etablissementController = TextEditingController();
  final epreuveController = TextEditingController();
  final motifController = TextEditingController();


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
  Future<void> createAbsence(candidat,epreuve,motif) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scan.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var salle = prefs.getString('salleSession');
    var examen =prefs.getString('type_examen_session');
    var total = prefs.getString('total_candidat');
    var etab = prefs.getString('name_etablissement');


    await database.insert('Absence',
        {'name_etablissement': etab, 'name_salle': salle, 'total': total, 'type_examen':examen, 'nom':candidat['nom'],
          'prenom':candidat['prenom'], 'code_eleve':candidat['code_eleve'], 'epreuve':epreuve, 'motif':motif, 'date':_getCurrentDate(), 'time':_getCurrentTime() });
    print('Absence inserted successfully.');
    Navigator.pop(this.context);

    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder:
                (context) =>
               const  ScanqrCode()));



  }



  @override
  void dispose() {
    etablissementController.dispose();
    motifController.dispose();
    epreuveController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
          margin:const  EdgeInsets.only(right: 15,left: 15),
          child: SingleChildScrollView(child: getBody())),



    );
  }

  Widget getBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: (){
              Navigator.pop(this.context);
            },
            child: const Icon(Icons.arrow_back_ios,size: 30,)),
        const SizedBox(
          height: 20,
        ),
        const Text('Une absence',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
        const Text('Veuillez remplir le formulaire afin enregistrer',style: TextStyle(fontSize: 13),),

        const SizedBox(
          height: 25,
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(this.context).size.width/7),
              child:  getCompleted(),
            ),

          ],
        ),
        const SizedBox(
          height: 25,
        ),


        const  SizedBox(
          height: 8,
        ),
        Center(
          child: GestureDetector(
            onTap: (){
              if (formkey.currentState!.validate()) {

                createAbsence(candidat,epreuveController.text,motifController.text);
              } else {

              }
            },
            child: Material(
              borderRadius: BorderRadius.circular(6),
              elevation: 3,
              color:   ColorsApp.colorPurpe,
              child: const Padding(
                  padding: EdgeInsets.only(right: 35,left: 35,top: 10,bottom: 10),
                  child:Text('Enregistrer',style: TextStyle(color: Colors.white,fontSize: 17),)),

            ),
          ),
        )

      ],
    );
  }

  Widget getCompleted(){
    return Column(
      children: [
        Form(
            key: formkey,
            child: formData())


      ],
    );
  }

  Widget formData(){
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin:const  EdgeInsets.only(right: 20,left: 20,top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(this.context).size.width/7,
            ),

            Container(
                width: MediaQuery.of(this.context).size.width,
                margin:const  EdgeInsets.only(bottom: 10,left: 5),
                child: const  Text("Motif")),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigné ce champ';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: motifController,
                decoration: InputDecoration(

                    prefixIcon: const Icon(Icons.home_work_outlined,color: ColorsApp.colorPurpe),
                    hintText: "Motif",
                    hintStyle: TextStyle(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder:   OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    // Ajouter cette ligne pour désactiver la bordure de mise au point
                    focusColor: Colors.white,
                    contentPadding: const EdgeInsets.all(5)
                ),
              ),
            ),
            const  SizedBox(
              height: 20,
            ),


            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigné ce champ';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: epreuveController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calculate,color: ColorsApp.colorPurpe),
                    hintText: "Matiere ou epreuve",
                    hintStyle: const TextStyle(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:const  BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    // Ajouter cette ligne pour désactiver la bordure de mise au point
                    focusColor: Colors.white,
                    contentPadding: const EdgeInsets.all(5)
                ),
              ),
            ),

            const  SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
