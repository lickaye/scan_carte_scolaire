import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_school/screen/index.dart';
import 'package:scan_school/screen/mes_rapports.dart';
import 'package:scan_school/screen/scan_qrcode.dart';
import 'package:scan_school/utils/colors_app.dart';


void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  // Définir la couleur de la barre d'état
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Couleur de la barre d'état
    statusBarIconBrightness: Brightness.dark, // Icônes de la barre d'état en noir
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan Exam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'productSans',

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: false,
      ),
      themeMode: ThemeMode.light,
      home:   MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: const IndexScreen(),
    );
  }
}
