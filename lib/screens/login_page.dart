import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_app/api.dart';
import 'package:test_app/background.dart';
import 'package:test_app/screens/home_page.dart';
import 'package:test_app/userSimplePreferences.dart';

import '../check_connectivity.dart';
import '../size_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StreamSubscription internetSubscription;

  String username = "";
  String password = "";
  bool isPasswordVisible = false;
  double bottom = 0;
  bool isVerificationFailed = false;

  @override
  void initState() {
    super.initState();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      if(!hasInternet){
        CheckConnectivity().showConnectivityBottomSheet(context);
      }
    });
    usernameController.addListener(() => setState(() {}));
  }

  @override
  void dispose(){
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    final isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    SizedConfig().init(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Color(0xff232323),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            if(MediaQuery.of(context).size.width < 650 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundSmall(),
            if(650 <= MediaQuery.of(context).size.width && MediaQuery.of(context).size.width < 1100 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundLarge(),
            if(1000 < MediaQuery.of(context).size.width && Orientation.landscape == MediaQuery.of(context).orientation) Background().backgroundUltraLarge(),
            Positioned(
              top:4.5*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              bottom: !isKeyBoard ?7*SizedConfig.heightMultiplier : 0,
              child: SingleChildScrollView(
                reverse: isKeyBoard,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Heading
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, 3*SizedConfig.heightMultiplier, 0, 3*SizedConfig.heightMultiplier
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Hello,",
                              style: TextStyle(
                                  fontFamily: 'Dela Gothic One',
                                  fontSize: 5.5*SizedConfig.heightMultiplier,
                                  color:Colors.white
                              ),
                            ),
                            AutoSizeText(
                              "Welcome Back",
                              style: TextStyle(
                                  fontFamily: 'Dela Gothic One',
                                  fontSize: 5.5*SizedConfig.heightMultiplier,
                                  color:Colors.white
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6*SizedConfig.heightMultiplier,
                      ),
                      if(isVerificationFailed) Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5*SizedConfig.widthMultiplier),
                        color: Colors.red,
                        height: 8.5*SizedConfig.heightMultiplier,
                        child:Row(
                          children:[
                            Padding(
                              padding:EdgeInsets.only(right: 4*SizedConfig.widthMultiplier),
                              child: Icon(FontAwesomeIcons.exclamationTriangle,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                            ),
                            Text(
                              'Authentication failed!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 3*SizedConfig.heightMultiplier,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ]
                        )
                      ),
                      //Form
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 2.5*SizedConfig.widthMultiplier,
                                    right: isPortrait
                                      ? MediaQuery.of(context).size.width<650 ? 2.4*SizedConfig.widthMultiplier : 3.6*SizedConfig.widthMultiplier
                                      : 2.2*SizedConfig.widthMultiplier
                                ),
                                margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(2*SizedConfig.heightMultiplier),topLeft:Radius.circular(2*SizedConfig.heightMultiplier) ),
                                  color: Colors.grey,
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[
                                      Padding(
                                        padding:EdgeInsets.only(right: 4*SizedConfig.widthMultiplier),
                                        child: Icon(FontAwesomeIcons.user,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                                            border: InputBorder.none,
                                            suffixIcon: usernameController.text.isEmpty
                                                ? Container(width: 0)
                                                : IconButton(
                                                    icon: Icon(Icons.close,color: Colors.white,size: 4*SizedConfig.heightMultiplier),
                                                    onPressed: () => usernameController.clear(),
                                                  ),
                                            errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier),
                                          ),
                                          style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                                          onSaved: (text){
                                            this.username = text;
                                          },
                                          keyboardType: TextInputType.phone,
                                          cursorColor: Colors.white,
                                          validator: (text){
                                            if(text.isEmpty){
                                              return "Please enter username";
                                            }else{
                                              return null;
                                            }
                                          },
                                        ),
                                      )

                                    ]
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(
                                    left: 2.5*SizedConfig.widthMultiplier,
                                    right: isPortrait
                                      ? 3.6*SizedConfig.widthMultiplier
                                      : 2.5*SizedConfig.widthMultiplier
                                ),
                                margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(2*SizedConfig.heightMultiplier),topLeft:Radius.circular(2*SizedConfig.heightMultiplier) ),
                                  color: Colors.grey,
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[
                                      Padding(
                                        padding:EdgeInsets.only(right: 4*SizedConfig.widthMultiplier),
                                        child: Icon(FontAwesomeIcons.key,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Password',
                                              labelStyle: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                icon: isPasswordVisible
                                                    ? Icon(FontAwesomeIcons.eye,color: Colors.white,size: 3.5*SizedConfig.heightMultiplier)
                                                    : Icon(FontAwesomeIcons.eyeSlash,color: Colors.white,size:3.5*SizedConfig.heightMultiplier),
                                                onPressed: (){
                                                  setState(() {
                                                    isPasswordVisible = !isPasswordVisible;
                                                  });
                                                },
                                              ),
                                              errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier)

                                          ),
                                          style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                                          obscureText: !isPasswordVisible,
                                          onSaved: (text){
                                            this.password = text;
                                          },
                                          cursorColor: Colors.white,
                                          validator: (text){
                                            if(text.isEmpty){
                                              return "Please enter password";
                                            }else{
                                              return null;
                                            }
                                          },
                                        ),
                                      )

                                    ]
                                ),
                              ),

                              //Signin button
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                child: InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 8.5*SizedConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                                      color: Colors.blueAccent,
                                    ),
                                    width: double.infinity,
                                    child: Text(
                                      'Signin',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 3*SizedConfig.heightMultiplier
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if(_formKey.currentState.validate()){
                                      _formKey.currentState.save();
                                      FocusScope.of(context).requestFocus(FocusNode());

                                      _login();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                )
              )
            ),
            if(!isKeyBoard)Positioned(
              bottom: 2*SizedConfig.heightMultiplier,
              child:Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width-24*SizedConfig.widthMultiplier,
                child: AutoSizeText(
                    "Powered By Devx Technologies",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.5*SizedConfig.heightMultiplier
                    ),
                    maxLines: 1,
                  ),
              ),
            ),
         ]
        )
      ),
    );
  }

  Future<void> _login() async{
    var data = {
      'username': this.username,
      'password': this.password
    };

    var res = await NetworkRequest().postRequest(data,'/api/v1/login');
    var body = jsonDecode(res.body); //convert into an array
    print(body['status']);
    if(body['status']){
      await UserSimplePreferences.setUserName(body['username']);
      await UserSimplePreferences.setFirstName(body['first_name']);
      await UserSimplePreferences.setLastName(body['last_name']);
      await UserSimplePreferences.setAddress(body['address']);
      await UserSimplePreferences.setProfilePicture(body['profile_image']);
      await UserSimplePreferences.setToken(body['token']);
      await UserSimplePreferences.setId(body['id']);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return HomePage();
              }
          )
      );
    }else{
      setState(() {
        this.isVerificationFailed = true;
      });
    }
  }
}
