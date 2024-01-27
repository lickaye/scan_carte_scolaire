import 'package:flutter/material.dart';
import 'package:scan_school/utils/colors_app.dart';

class detailSearch extends StatefulWidget {
  final Map<String, dynamic> candidat;
    detailSearch({super.key,required this.candidat});

  @override
  State<detailSearch> createState() =>   _detailSearchState(candidat:candidat);
}

class _detailSearchState extends State<detailSearch> {
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
          children: [
        const SizedBox(height: 25,),
              SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                  backgroundImage: AssetImage('asset/search.webp')

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  candidat['nom'],
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  candidat['prenom'],
                  style: const TextStyle(fontSize: 22),
                )
              ],
            ),
            Text(
              "Code: ${ candidat['code_eleve']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15,),
            Text(
              "Date naissance: ${ candidat['date_naissance']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25,),
            GestureDetector(

              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(6),


                child:   const Padding(
                    padding:  EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 10),
                    child: Text('Valider',style: TextStyle(fontSize: 16,color: ColorsApp.colorPurpe),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
