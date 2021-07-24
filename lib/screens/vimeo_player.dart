import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_app/size_config.dart';
import 'package:test_app/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:dio/dio.dart';
import '../quality_links.dart';

import '../background.dart';
import '../check_connectivity.dart';

// ignore: must_be_immutable
class VimeoPlayer extends StatefulWidget {
  String urlId;
  String heading;
  String title;
  String downloadFile;
  int lessonId;
  int courseId;


  VimeoPlayer({
    @required this.urlId,
    @required this.heading,
    @required this.title,
    @required this.downloadFile,
    @required this.lessonId,
    @required this.courseId
  });

  @override
  _VimeoPlayerState createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {

  StreamSubscription internetSubscription;
  bool hasInternet = false;
  VideoPlayerController controller;
  var dio = Dio();


  //Quality Class
  QualityLinks _quality;
  Map _qualityValues;
  var _qualityValue;


  @override
  void initState() {
    super.initState();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event){
      final hasInternet = event == InternetConnectionStatus.connected;
      print(hasInternet);
      print('hello vimeo');
      if(!hasInternet){
        CheckConnectivity().showConnectivityBottomSheet(context);
      }
      //Create class
      _quality = QualityLinks(widget.urlId);

      //Инициализация контроллеров видео при получении данных из Vimeo
      _quality.getQualitiesSync().then((value) {
        _qualityValues = value;
        _qualityValue = value[value.lastKey()];

        controller = VideoPlayerController.network(_qualityValue)
          ..addListener(()=> setState((){}))
          ..setLooping(false)
          ..initialize().then((_) => controller.pause());


      });

      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    preferredOrientations();
    wakeLockEnable();//Device state stay awake(doesn't sleep)
    avoidScreenRecording();
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    setSystemUIOverlaysEnable();
    preferredOrientations();
    wakeLockDisable();
    controller.dispose();
    super.dispose();
  }

  Future preferredOrientations() async{
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeLeft
    ]);
  }

  Future setSystemUIOverlaysDisable() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);//Remove statis bar in the top
  }

  Future wakeLockEnable() async{
    await Wakelock.enable(); //Device state stay awake(doesn't sleep)
  }
  Future setSystemUIOverlaysEnable() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  Future wakeLockDisable() async{
    await Wakelock.disable(); //Device state stay awake(doesn't sleep)
  }

  Future avoidScreenRecording() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  @override
  Widget build(BuildContext context) {
    final isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    if(isPortrait) {
      setSystemUIOverlaysEnable() ;
    }else{
      setSystemUIOverlaysDisable();
    }
    // print(controller != null);
    // print(controller.value.isInitialized);
    SizedConfig().init(context);
    return SafeArea(
      bottom: false,
      top: false,
      left: false,
      right: false,
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
              if(isPortrait) Positioned(
                top:4*SizedConfig.heightMultiplier,
                right: 6*SizedConfig.widthMultiplier,
                left: 6*SizedConfig.widthMultiplier,
                bottom: 0,
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
                                  widget.title.toUpperCase(),
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
                        child: Text(widget.heading,style: TextStyle(fontSize: 4.5*SizedConfig.heightMultiplier,color: Colors.white,fontWeight: FontWeight.w500),),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                        child: VideoPlayerWidget(controller: controller,lessonId: widget.lessonId,courseId: widget.courseId,),
                      ),
                      if(widget.downloadFile.isNotEmpty) Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                                color: Colors.blueAccent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Icon(Icons.download,size: 4*SizedConfig.heightMultiplier,color: Colors.white,),
                                  SizedBox(width: 3*SizedConfig.widthMultiplier),
                                  Text(
                                    'Download File',
                                    style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,color: Colors.white),
                                  )
                                ]
                              )
                            ),
                            onTap: () async{
                              _requestDownload(widget.downloadFile);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(!isPortrait) Container(
                child: VideoPlayerWidget(controller: controller,lessonId: widget.lessonId,courseId: widget.courseId,),
              )
            ]
        ),
      ),
    );
  }


  void _requestDownload(String link) async {
    final taskId = await FlutterDownloader.enqueue(
      url: link,
      savedDir: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS),
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
  }

}
