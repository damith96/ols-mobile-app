import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_app/screens/edit_profile_page.dart';
import 'package:test_app/size_config.dart';
import 'package:test_app/userSimplePreferences.dart';
import 'dart:io';

import '../background.dart';
import '../check_connectivity.dart';

_ViewProfileState viewProfileState;

// ignore: must_be_immutable
class ViewProfile extends StatefulWidget {

  @override
  _ViewProfileState createState() {
    viewProfileState = _ViewProfileState();
    return viewProfileState;
  }
}

class _ViewProfileState extends State<ViewProfile> {

  StreamSubscription internetSubscription;
  bool hasInternet = false;
  String userName;
  String firstName;
  String lastName;
  String address;
  //File _imageFile;
  String _imageUrl;

  @override
  void initState() {
    super.initState();

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event){
      final hasInternet = event == InternetConnectionStatus.connected;
      print(hasInternet);
      if(!hasInternet){
        CheckConnectivity().showConnectivityBottomSheet(context);
      }

      setState(() {
        this.hasInternet = hasInternet;
      });
    });

    userName = UserSimplePreferences.getUserName() ?? '';
    firstName = UserSimplePreferences.getFirstName() ?? '';
    lastName = UserSimplePreferences.getLastName() ?? '';
    address = UserSimplePreferences.getAddress() ?? '';

    if(UserSimplePreferences.getProfilePicture() != null){
      _imageUrl = UserSimplePreferences.getProfilePicture();
    }


  }

  void resetVariables(String username, String firstName, String lastName, String address,File file){
      this.userName = username;
      this.firstName = firstName;
      this.lastName = lastName;
      this.address = address;
      //this._imageFile = file;
  }

  @override
  void dispose() {
    print('dispose');
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                //Profile
                Positioned(
                  top: 6*SizedConfig.heightMultiplier,
                  left: 10*SizedConfig.widthMultiplier,
                  child: Container(
                    child: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 3.5*SizedConfig.heightMultiplier
                        )
                    ),
                  )
                ),

                //Avatar
                Positioned(
                  top: 13*SizedConfig.heightMultiplier,
                  child: Container(
                    child: hasInternet
                      ? CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 11.5*SizedConfig.heightMultiplier,
                          /*backgroundImage: _imageFile == null
                              ? AssetImage("assets/images/profile_image.jpg")
                              : FileImage(_imageFile),*/
                          backgroundImage: AssetImage("assets/images/profile_image.jpg"),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.black12,
                          child: CircularProgressIndicator(),
                          radius: 11.5*SizedConfig.heightMultiplier,
                        )
                  ),
                ),

                //ListItems
                Positioned(
                  top:36.5*SizedConfig.heightMultiplier,
                  bottom: 10.5*SizedConfig.heightMultiplier,
                  right: 6*SizedConfig.widthMultiplier,
                  left: 6*SizedConfig.widthMultiplier,
                  child:Container(
                    child:ListView(
                      children: [
                        textFields("Username", userName, FontAwesomeIcons.userAlt),
                        textFields("First Name", firstName, FontAwesomeIcons.addressBook),
                        textFields("Last Name", lastName, FontAwesomeIcons.solidAddressBook),
                        textFields("Address", address, FontAwesomeIcons.addressCard)
                      ],
                    )
                  )
                ),

                //EditButton
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
                        child:Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 4*SizedConfig.heightMultiplier,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          internetSubscription.cancel();
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context){
                            return EditProfilePage();
                          }
                          ));
                        },
                  ),
                )
              ]
          )
      ),
    );
  }

  Widget textFields(String text1, String text2,icon){
    return Container(
      padding: EdgeInsets.all(2.5*SizedConfig.heightMultiplier),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
      decoration: BoxDecoration(
        border: Border.all(width:SizedConfig.heightMultiplier/3,color: Colors.white),
        borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft: Radius.circular(1.5*SizedConfig.heightMultiplier)),
        color: Colors.grey
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 4*SizedConfig.heightMultiplier,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5*SizedConfig.widthMultiplier),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1,style: TextStyle(fontSize: 1.5*SizedConfig.heightMultiplier,color: Colors.white),),
                Container(
                  width: 60.5*SizedConfig.widthMultiplier,
                  child: AutoSizeText(
                    text2,
                    style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                    maxLines: 3,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
