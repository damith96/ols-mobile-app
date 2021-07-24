import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_app/screens/vimeo_player.dart';

import '../api.dart';
import '../background.dart';
import '../check_connectivity.dart';
import '../search_widget.dart';
import '../size_config.dart';
import '../userSimplePreferences.dart';
import 'access_denied.dart';
import 'access_expired.dart';

class MyLessons extends StatefulWidget {

  String title;
  int courseId;

  MyLessons({
    Key key,
    @required this.title,
    @required this.courseId
  }) : super(key: key);

  @override
  _MyLessonsState createState() => _MyLessonsState();
}

class _MyLessonsState extends State<MyLessons> {

  StreamSubscription internetSubscription;
  bool hasInternet = false;
  String query = '';
  List<String> list = [];
  List<String> visibleList;
  bool dataAdded = false;
  int count = 0;
  List resList;

  @override
  void initState() {
    super.initState();

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event) {
          final hasInternet = event == InternetConnectionStatus.connected;
          if (!hasInternet) {
            setState(() {
              CheckConnectivity().showConnectivityBottomSheet(context);
              this.hasInternet = hasInternet;
            });
          } else {
            if (!this.dataAdded) {
              loadData(hasInternet);
            } else {
              setState(() {
                this.hasInternet = hasInternet;
              });
            }
          }
    });
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  Future<void> loadData(bool hasInternet) async{
    await getMyLessons();
    this.hasInternet = hasInternet;
    this.dataAdded = true;
    setState(() {});
  }

  Future<void> getMyLessons() async{
    int id = UserSimplePreferences.getId();
    int courseId = widget.courseId;
    var res = await NetworkRequest().getData('/api/v1/courses/my/$id/$courseId/lessons');
    var body = jsonDecode(res.body);
    this.resList = body['data'];
    this.count = body['count'];
    for(var i=0;i<this.count;i++){
      list.add(resList[i]['lesson_title']);
    }
    visibleList = list;
  }

  @override
  Widget build(BuildContext context) {
    final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
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
              top:4.5*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              bottom: 0,
              child: Container(
                child: Column(
                  children: [
                    if(!isKeyBoard)Container(
                      height: 14*SizedConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/OLS Logo-white.png"),
                            fit: BoxFit.fitHeight
                        ),
                      ),
                    ),
                    if(!isKeyBoard)Card(
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
                              height: 11.5*SizedConfig.heightMultiplier,
                              fit: BoxFit.cover
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 1*SizedConfig.heightMultiplier,right: 2.5*SizedConfig.widthMultiplier),
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
                          ),
                          Positioned(
                              right: 4.5*SizedConfig.widthMultiplier,
                              top: 0.5*SizedConfig.heightMultiplier,
                              child: Icon(
                                FontAwesomeIcons.graduationCap,
                                size: 4.5*SizedConfig.heightMultiplier,
                                color: Colors.white,
                              )
                          )
                        ],
                      ),
                    ),
                    buildSearch(),

                    hasInternet
                      ? visibleList.isNotEmpty
                        ? Expanded(
                            child: Container(
                              child: ListView.builder(
                                  itemCount: visibleList.length,
                                  itemBuilder: (context, index){
                                    final text = visibleList[index];
                                    return buildItems(text,resList[index]['lesson_thumbnail_image'],resList[index]['lesson_id'],resList[index]['lesson_video_url'],resList[index]['lesson_file'],resList[index]['is_expired']);
                                  }
                              )      ,
                            ),
                          )
                        : Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Image(
                                        image: AssetImage("assets/images/404.png"),
                                        height: 29*SizedConfig.heightMultiplier,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Text('No Results Founds!',style: TextStyle(fontSize: 4*SizedConfig.heightMultiplier,color: Colors.white,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 6*SizedConfig.heightMultiplier,),
                                    InkWell(
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
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      : Expanded(
                        child: Container(
                            child: Center(
                              child: SizedBox(
                                  width: 6*SizedConfig.heightMultiplier,
                                  height: 6*SizedConfig.heightMultiplier,
                                  child: CircularProgressIndicator(strokeWidth: 5.0,)
                              ),
                            )
                    ),
                  )
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildItems(String text,String image,int lessonId,String video,String file,bool isExpired) {
    return Container(
      alignment: Alignment.center,
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
      padding: EdgeInsets.symmetric(vertical: 2.5*SizedConfig.heightMultiplier,horizontal: 3.5*SizedConfig.widthMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
        color: Colors.black,
      ),
      child: ListTile(
          leading: Container(
            width: 7*SizedConfig.heightMultiplier,
            height: 7*SizedConfig.heightMultiplier,
            child: Image.network(image),
          ),
          title: Text(text,style: TextStyle(color: Colors.white,fontSize: 3.5*SizedConfig.heightMultiplier),),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            if(isExpired){
              internetSubscription.cancel();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return AccessExpired(courseTitle: widget.title,heading: text);

                  }
              ));
            }else{
              internetSubscription.cancel();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return VimeoPlayer(urlId:video,title: widget.title,heading: text,downloadFile: file,lessonId: lessonId,courseId: widget.courseId);
                  }
              ));
            }
          }
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search a lesson',
    onChanged: searchCourse,
  );

  void searchCourse(String query) {
    visibleList = list.where((course) {
      final courseTitle = course.toLowerCase();
      final searchTitle = query.toLowerCase();

      return courseTitle.contains(searchTitle);
    }).toList();

    setState(() {
      this.query = query;
    });

  }
}
