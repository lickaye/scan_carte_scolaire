
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_school/screen/scren_config.dart';
import 'package:scan_school/utils/colors_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';


class createClassRoom extends StatefulWidget {
  final String img;
  final String name;
    createClassRoom({super.key,required this.img,required this.name});

  @override
  State<createClassRoom> createState() => _createClassRoomState(img:img,name:name);
}

class _createClassRoomState extends State<createClassRoom> {

  final String img;
  final String name;
  _createClassRoomState({required this.img,required this.name});

  final formkey = new GlobalKey<FormState>();
  final etablissementController = TextEditingController();
  final salleController = TextEditingController();
  final candidatController = TextEditingController();
  bool salleExist =false;
  List<Map<String, dynamic>> _allSalle = [];

  Future dataBaseCreate(etab,salle,total) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scan.db');

    // open the database

    Database database = await openDatabase(path, version: 1,
        );




    // Check if a record with the given name_salle already exists

    List<Map<String, dynamic>> existingRecords = await database.query(
      'Salle',
      where: 'name_salle = ? AND type_examen = ?',
      whereArgs: [salle.trim(), name],
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (existingRecords.isEmpty) {
      // If no record found, insert a new one
      prefs.setString('salleSession', salle.trim());
      prefs.setString('type_examen_session', name);
      prefs.setString('total_candidat', total);
      prefs.setString('name_etablissement', total);

      await database.insert('Salle',
          {'name_etablissement': etab, 'name_salle': salle.trim(), 'total': total, 'type_examen':name});
      print('Record inserted successfully.');
      Navigator.push(
          this.context,
          MaterialPageRoute(
              builder:
                  (context) =>
                  ScreenConfig(img: img,name: name,)));

      setState(() {
        salleExist = false;
      });
    } else {
      setState(() {
        salleExist = true;
      });
      // If a record with the same name_salle exists, you can choose to update it or handle it accordingly.
      print('Record with name_salle already exists.');
    }

   // print('student inserer');
    // Close the database connection
    await database.close();

//06 480 62 32

  }





  //RECUPEATION DES SALLES
  Future<void> dataStudent() async {

    final String path = join(await getDatabasesPath(), 'scan.db');
    final Database database = await openDatabase(path, version: 1);
    //Delete the database
   // await deleteDatabase(path);
    _allSalle = await database.query('Salle');
    setState(() {
      _allSalle;
    });
  }

  @override
  void initState() {
    //dataStudent();
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    etablissementController.dispose();
    salleController.dispose();
    candidatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Lste des sallle:${_allSalle}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
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
            child: const Icon(Icons.keyboard_backspace_outlined,size: 30,)),
        const SizedBox(
          height: 20,
        ),
        const Text('La classe virtuelle',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
        const Text('Veuillez remplir le formulaire afin de poursuire le processus de scan des candidats',style: TextStyle(fontSize: 13),),

        const SizedBox(
          height: 25,
        ),
       Stack(
         children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(this.context).size.width/7),
            child:  getCompleted(),
          ),
           Positioned(


               child: Align(
                 alignment: Alignment.center,
                 child: Container(
                   width: MediaQuery.of(this.context).size.width/2.5,
                   height: 100,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                           spreadRadius: 0,  // L'écart de diffusion de l'ombre
                           blurRadius: 0.5,    // Le rayon de flou de l'ombre
                           //offset: Offset(0, 0), // L'offset de l'ombre par rapport à la boîte
                         ),
                       ],
                       image:   DecorationImage(
                         image: AssetImage('asset/$img'),
                         fit: BoxFit.cover,
                       )

                   ),

                 ),
               ))
         ],
       ),
        const SizedBox(
          height: 25,
        ),

        salleExist ? const  Center(
          child: Text('Cette salle existe deja veuillez changer de salle',style: TextStyle(
            color: Colors.red
          ),),
        ):SizedBox(),
       const  SizedBox(
          height: 8,
        ),
        Center(
          child: GestureDetector(
            onTap: (){
              if (formkey.currentState!.validate()) {
                _showBottomSheet(this.context);

              } else {

              }
            },
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(6),
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
               child: const  Text("Centre d'examen")),
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
               controller: etablissementController,
               decoration: InputDecoration(
                 prefixIcon: const  Icon(Icons.school,color: ColorsApp.colorPurpe,),
                 hintText: "Etablissement ou centre",
                 hintStyle: const TextStyle(),
                 enabledBorder:const  OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.white),
                 ),
                 focusedBorder: OutlineInputBorder(
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
               width: MediaQuery.of(this.context).size.width,
               margin:const  EdgeInsets.only(bottom: 10,left: 5),
               child: const  Text("Salle d'examen")),
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
               keyboardType: TextInputType.number,
               controller: salleController,
               decoration: InputDecoration(

                   prefixIcon: const Icon(Icons.home_work_outlined,color: ColorsApp.colorPurpe),
                   hintText: "Entrer la salle",
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
               width: MediaQuery.of(this.context).size.width,
               margin:const  EdgeInsets.only(bottom: 10,left: 5),
               child: const  Text("Nombres total des candidats")),
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
               keyboardType: TextInputType.number,
               controller: candidatController,
               decoration: InputDecoration(
                   prefixIcon: const Icon(Icons.calculate,color: ColorsApp.colorPurpe),
                   hintText: "Nombre des candidats",
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

  Future<void> showDialogConfirm() async {
    showCupertinoDialog(
      context: this.context,
      builder: (BuildContext context) => Theme(
          data: ThemeData.light(),
          child: CupertinoAlertDialog(
            title: const Text('Success...',
              style: TextStyle(fontFamily: 'productSans',fontSize: 15,fontWeight: FontWeight.w500),),
            content: Center(
              child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Icon(
                        Icons.task_alt,
                        color: Colors.green,
                        size: 70,
                      ),
                      const Text(
                        'votre message a été envoyé avec succès',
                        style:TextStyle(),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Material(
                          elevation: 12,
                          color: const Color(0xFF27AE60),
                          borderRadius: BorderRadius.circular(25),
                          child: Padding(
                            padding: EdgeInsets.only(right: 35,left: 35,top: 8,bottom: 8),
                            child: Text('Valider'),
                          ),
                        ),
                      )

                    ],
                  )),
            ),
            actions: [],
          )),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: Container(
              
            height: MediaQuery.of(context).size.width/1,
            color: Colors.white,
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child:  Align(
                     alignment: Alignment.topLeft,
                     child: Padding(
                         padding: EdgeInsets.all(12),
                         child: Icon(Icons.cancel,size: 50,))),),

                  Column(
                    children: [
                      Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 15,left: 15,bottom: 10),
                          child: Text("Etablissement: ${etablissementController.text}",style: TextStyle(fontSize: 17),))),
                      Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 15,left: 15,bottom: 10),
                          child: Text("Salle: ${salleController.text}",style: TextStyle(fontSize: 17),))),
                      Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 15,left: 15,bottom: 10),
                          child: Text("Total des candidats: ${candidatController.text}",style: TextStyle(fontSize: 17),))),
                    ],
                  ),
                  const Text('This is a bottom sheet'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      dataBaseCreate(etablissementController.text,salleController.text,candidatController.text);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 30,left: 30),
                        child: Text('Valider')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
