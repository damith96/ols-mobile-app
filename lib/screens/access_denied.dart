import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/size_config.dart';

import '../background.dart';
import 'all_courses.dart';

class AccessDenied extends StatelessWidget {

  final String courseTitle;
  final String heading;

  AccessDenied({
    Key key, this.courseTitle, this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizedConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xff232323),
      body: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.antiAlias,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),

            if(MediaQuery.of(context).size.width < 650 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundSmall(),
            if(650 <= MediaQuery.of(context).size.width && MediaQuery.of(context).size.width < 1100 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundLarge(),
            if(1000 < MediaQuery.of(context).size.width && Orientation.landscape == MediaQuery.of(context).orientation) Background().backgroundUltraLarge(),
            Positioned(
              top:4*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              bottom: 11*SizedConfig.heightMultiplier,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 14*SizedConfig.heightMultiplier,
                        width: 60*SizedConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/OLS Logo-white.png"),
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier) //Need to change
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Image(
                                image: AssetImage("assets/images/welcome_widget_.png"),
                                width: MediaQuery.of(context).size.width,
                                height: 11.5*SizedConfig.heightMultiplier,
                                fit: BoxFit.cover
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.5*SizedConfig.heightMultiplier,right: 2.5*SizedConfig.widthMultiplier),
                              child: Container(
                                alignment: Alignment.topRight,
                                width: 63*SizedConfig.widthMultiplier,
                                child: AutoSizeText(
                                  this.courseTitle.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 4.5*SizedConfig.heightMultiplier,
                                      fontWeight: FontWeight.bold
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                        alignment: Alignment.centerLeft,
                        child: Text(this.heading,style: TextStyle(fontSize: 4.5*SizedConfig.heightMultiplier,color: Colors.white,fontWeight: FontWeight.w500),),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            //Go back button
            Positioned(
              bottom:1.5*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF)
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 5*SizedConfig.heightMultiplier,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2.5*SizedConfig.widthMultiplier),
                      Text(
                        "Go Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 4*SizedConfig.heightMultiplier,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).pop(AllCourses());
                },
              ),
            )
          ]
      ),
    );
  }
}
