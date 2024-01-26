import 'package:flutter/material.dart';
import 'package:scan_school/screen/create_classroom.dart';
import 'package:scan_school/screen/scan_qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenConfig extends StatefulWidget {
  final String img;
  final String name;
    ScreenConfig({super.key,required this.img,required this.name});

  @override
  State<ScreenConfig> createState() => _ScreenConfigState(img:img,name:name);
}

class _ScreenConfigState extends State<ScreenConfig> {
  final String img;
  final String name;
  _ScreenConfigState({required this.img,required this.name});

var sessionSalle;
  Future<void> salleSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedSalle = prefs.getString('salleSession');
    setState(() {
      sessionSalle = storedSalle.toString();
    });
  }

  @override
  void initState() {
    salleSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('sessionSalle:$sessionSalle');
    return sessionSalle=='null' ? createClassRoom(img: img,name: name,):  const ScanqrCode();
  }
}
