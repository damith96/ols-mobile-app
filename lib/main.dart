import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:test_app/screens/hhh.dart';
import 'package:test_app/userSimplePreferences.dart';

import 'screens/access_expired.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/my_lessons.dart';
import 'screens/vimeo_player.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  // runApp(DevicePreview(
  //   builder: (context)=>MyApp(),
  // ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    preferredOrientations();
  }

  Future preferredOrientations() async{
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'OLS Video App',
      theme: ThemeData(
        accentColor: Colors.transparent,
        primarySwatch: Colors.blue,
        canvasColor: Colors.transparent
      ),
      home:CheckAuth()
    );
  }

}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn(){
    var token = UserSimplePreferences.getToken();
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = HomePage();
    } else {
      child = LoginPage();
    }
    return child;
  }
}

