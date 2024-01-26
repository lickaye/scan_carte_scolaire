
import 'package:flutter/material.dart';

import 'package:scan_school/utils/colors_app.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class mesRapports extends StatefulWidget {
  const mesRapports({super.key});

  @override
  State<mesRapports> createState() => _mesRapportsState();
}

class _mesRapportsState extends State<mesRapports> {






  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              leadingWidth: MediaQuery.of(context).size.width,
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8, right: 8, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Mes rapports',
                          style: TextStyle(color: Colors.black,fontSize: 22),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
