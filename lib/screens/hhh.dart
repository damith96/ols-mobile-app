import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/screens/access_denied.dart';
import 'package:test_app/screens/edit_profile_page.dart';
import 'package:video_player/video_player.dart';

import '../size_config.dart';

class hhh extends StatefulWidget {

  @override
  _hhhState createState() => _hhhState();
}

class _hhhState extends State<hhh> {

  int number = 1;
  @override
  void initState() {
    print('Inilialize $number');
    super.initState();
  }


  @override
  void dispose() {
    print('Dispose $number');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Build $number');
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(number.toString(),style: TextStyle(fontSize: 20.0),),
            ElevatedButton(
              child: Text('Hello',style: TextStyle(fontSize: 20.0),),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context){
                          return AccessDenied(heading: 'rfrfr',courseTitle: 'rfrf',);
                        }
                    )
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          setState(() {
            number += 1;
          });
        },
      ),
    );
  }
}
