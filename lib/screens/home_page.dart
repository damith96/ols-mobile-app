import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/api.dart';
import 'package:test_app/screens/all_courses.dart';
import 'package:test_app/screens/call_center.dart';
import 'package:test_app/screens/login_page.dart';
import 'package:test_app/screens/my_courses.dart';
import 'package:test_app/screens/view_profile.dart';
import 'package:test_app/userSimplePreferences.dart';


import '../background.dart';
import '../size_config.dart';

_HomePageState homePageState;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    homePageState = _HomePageState();
    return homePageState;
  }
}

class _HomePageState extends State<HomePage> {

  List<String> greetings = ['Good morning','Good afternoon','Good evening','Good night'];
  String firstName = '';
  List<IconData> icons = [FontAwesomeIcons.solidMoon,Icons.wb_sunny_rounded];
  String greeting = '';
  IconData icon;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) => setState(() {}));
    firstName = UserSimplePreferences.getFirstName() ?? '';
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setName(String name) {
    setState(() {
      this.firstName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if(6 <= now.hour && now.hour < 12){
      this.greeting = greetings[0];
      this.icon = icons[1];
    }else if(12 <= now.hour && now.hour < 15){
      this.greeting = greetings[1];
      this.icon = icons[1];
    }else if(15 <= now.hour && now.hour < 19){
      this.greeting = greetings[2];
      this.icon = icons[1];
    }else if(19 <= now.hour && now.hour <= 23){
      this.greeting = greetings[3];
      this.icon = icons[0];
    }else if(00 <= now.hour && now.hour < 6){
      this.greeting = greetings[3];
      this.icon = icons[0];
    }

    SizedConfig().init(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
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
                Container(
                  margin: EdgeInsets.only(top:4.5*SizedConfig.heightMultiplier),
                  height: 14*SizedConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/OLS Logo-white.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  top:19*SizedConfig.heightMultiplier,
                  right: 6*SizedConfig.widthMultiplier,
                  left: 6*SizedConfig.widthMultiplier,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier)
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image(
                            image: AssetImage("assets/images/welcome_widget_.png"),
                            width: MediaQuery.of(context).size.width,
                            height: 12*SizedConfig.heightMultiplier,
                            fit: BoxFit.cover
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.5*SizedConfig.heightMultiplier,right: 3*SizedConfig.widthMultiplier),
                          child: Container(
                            alignment: Alignment.topRight,
                            width: 52*SizedConfig.widthMultiplier,
                            child: AutoSizeText(
                              firstName.isEmpty ? '${this.greeting}' : '${this.greeting}, ${this.firstName}', //Have check here
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:3*SizedConfig.heightMultiplier,
                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 3*SizedConfig.widthMultiplier,
                            top: 1.5*SizedConfig.heightMultiplier,
                            child: Icon(
                              this.icon,
                              size: 4.5*SizedConfig.heightMultiplier,
                              color: Colors.white,
                            )
                        ),
                        Positioned(
                          bottom: 1.5*SizedConfig.heightMultiplier,
                          left: 13*SizedConfig.widthMultiplier,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${now.day}',
                                  style: TextStyle(
                                    fontSize: 6*SizedConfig.heightMultiplier,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${now.month}, ${now.year}',
                                  style: TextStyle(
                                    fontSize: 2.2*SizedConfig.heightMultiplier,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      6*SizedConfig.widthMultiplier,32*SizedConfig.heightMultiplier,
                      6*SizedConfig.widthMultiplier,10.5*SizedConfig.heightMultiplier
                  ),
                  child: ListView(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width-12*SizedConfig.widthMultiplier)/2.0,
                              child: Column(
                                children: [
                                  cards(3*SizedConfig.heightMultiplier, "assets/images/widget_1.png", 29*SizedConfig.heightMultiplier, context,FontAwesomeIcons.graduationCap,"MY", "COURSES",CrossAxisAlignment.end,MyCourses()),
                                  cards(3*SizedConfig.heightMultiplier, "assets/images/widget_3.png", 43*SizedConfig.heightMultiplier, context,FontAwesomeIcons.phoneVolume,"CALL", "CENTER",CrossAxisAlignment.end,CallCenter())
                                ],
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width-12*SizedConfig.widthMultiplier)/2.0,
                              child: Column(
                                children: [
                                  cards(3*SizedConfig.heightMultiplier, "assets/images/widget_2.png", 43*SizedConfig.heightMultiplier, context,FontAwesomeIcons.listAlt,"ALL", "COURSES",CrossAxisAlignment.start,AllCourses()),
                                  cards(3*SizedConfig.heightMultiplier, "assets/images/widget_4.png", 29*SizedConfig.heightMultiplier, context,FontAwesomeIcons.userAlt,"MY", "PROFILE",CrossAxisAlignment.start,ViewProfile())
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                  ),
                ),

                //Signout Button
                Positioned(
                  bottom:1.5*SizedConfig.heightMultiplier,
                  right: 6*SizedConfig.widthMultiplier,
                  left: 6*SizedConfig.widthMultiplier,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1*SizedConfig.heightMultiplier),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                        color: Colors.red
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.signOutAlt,
                              size: 5.5*SizedConfig.heightMultiplier,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 2.5*SizedConfig.widthMultiplier,),
                          Text(
                            "Signout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 5*SizedConfig.heightMultiplier,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      logout();
                    },
                  ),
                ),
              ]
          )
      ),
    );
  }

  Future<void> logout() async{
    UserSimplePreferences.removeToken();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context){
              return LoginPage();
            }
        )
    );
  }
    /*var res = await NetworkRequest().getData('/logout');
    var body = jsonDecode(res.body);
    if(body['success']){

      UserSimplePreferences.removeUserName();
      UserSimplePreferences.removeFirstName();
      UserSimplePreferences.removeLastName();
      UserSimplePreferences.removeAddress();
      UserSimplePreferences.removeProfilePicture();
      UserSimplePreferences.removeId();
      UserSimplePreferences.removeToken();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return LoginPage();
              }
          )
      );
    }
  }*/
}

Widget cards(double radius,String path, double height,BuildContext context,
    IconData icon,String text1,String text2,CrossAxisAlignment alignment,
    Widget classWidget){
  return Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius)
    ),
    child: Stack(
      children: [
        Ink.image(
            image: AssetImage(path),
            width: MediaQuery.of(context).size.width,
            height: height,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: (){
                /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context){
                          return classWidget;
                        }
                    )
                );*/
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return classWidget;
                      //VimeoPlayer(url:'assets/Video.mp4',);
                    }
                ));
              },
              child: Stack(
                children: [
                    Positioned(
                      left: 3.5*SizedConfig.widthMultiplier,
                      top: 2*SizedConfig.heightMultiplier,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 6*SizedConfig.heightMultiplier,
                      ),
                    ),
                    Positioned(
                      bottom: 1.5*SizedConfig.heightMultiplier,
                      right: 3*SizedConfig.widthMultiplier,
                      left: 3*SizedConfig.widthMultiplier,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: alignment,
                          children: [
                            AutoSizeText(
                              text1,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 3.5*SizedConfig.heightMultiplier
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              text2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 3.5*SizedConfig.heightMultiplier
                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ),
        )
      ],
    ),
  );
}