import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:test_app/api.dart';
import 'package:test_app/screens/call_center.dart';
import 'package:test_app/size_config.dart';

import '../background.dart';
import '../check_connectivity.dart';
import '../userSimplePreferences.dart';

class SubmitPayment extends StatefulWidget {

  @override
  _SubmitPaymentState createState() => _SubmitPaymentState();
}

class _SubmitPaymentState extends State<SubmitPayment> {

  StreamSubscription internetSubscription;
  final courseController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDropDown = false;
  final controller = TextEditingController();
  List list = [];
  List<String> courseList = [];
  int count = 0;

  String value = '';
  String date = '';
  String courseId = '';
  String amount = '';
  String refNo = '';
  String note = '';

  @override
  void initState() {
    super.initState();

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event){
      final hasInternet = event == InternetConnectionStatus.connected;
      print(hasInternet);
      if(!hasInternet){
        CheckConnectivity().showConnectivityBottomSheet(context);
      }else{
        setState(() {
          getAllCourses();
        });
      }
    });

  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  Future<void> getAllCourses() async{
    var res = await NetworkRequest().getData('/api/v1/courses');
    var body = jsonDecode(res.body);
    this.list = body['data'];
    this.count = body['count'];
    for(var i=0;i<this.count;i++){
      courseList.add(list[i]['title']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
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
                                    "SUBMIT PAYMENT",
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
                                  right: 2*SizedConfig.widthMultiplier,
                                  top: 0.6*SizedConfig.heightMultiplier,
                                  child: Container(
                                    child: Icon(
                                      Icons.monetization_on,
                                      size: 4.5*SizedConfig.heightMultiplier,
                                      color: Colors.white,
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.5*SizedConfig.widthMultiplier),
                          child: Form(
                            key: _formKey,
                            child: Column(
                                children: [
                                  Container(
                                    height: isPortrait ? 9*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                                    padding: EdgeInsets.symmetric(horizontal: 4*SizedConfig.widthMultiplier,),
                                    margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft:Radius.circular(1.5*SizedConfig.heightMultiplier) ),
                                      color: Colors.grey,
                                    ),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                          Padding(
                                            padding:EdgeInsets.only(right: isPortrait ? 5.8*SizedConfig.widthMultiplier : 5*SizedConfig.widthMultiplier),
                                            child: Icon(FontAwesomeIcons.calendarAlt,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: dateController,
                                              decoration: InputDecoration(
                                                hintText: 'Date',
                                                hintStyle: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                                border: InputBorder.none,
                                                errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier)

                                              ),
                                              style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                              onSaved: (text){
                                                this.date = text;
                                              },
                                              cursorColor: Colors.white,
                                              validator: (text){
                                                if(text.isEmpty){
                                                  return "Enter date";
                                                }else{
                                                  return null;
                                                }
                                              },
                                              readOnly: true,
                                              onTap: () async{
                                                final initialDate = DateTime.now();
                                                final newDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: initialDate,
                                                    firstDate: DateTime(DateTime.now().year - 5),
                                                    lastDate: DateTime(DateTime.now().year + 5)
                                                );

                                                if(newDate != null) {
                                                  final date = DateFormat('yyyy-MM-dd').format(newDate);
                                                  dateController.text = date;
                                                }
                                              },
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  Container(
                                    height: isPortrait ? 9*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                                    margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                    padding: MediaQuery.of(context).size.width<650
                                      ? EdgeInsets.only(left: 4*SizedConfig.widthMultiplier)
                                      : isPortrait
                                        ? EdgeInsets.symmetric(horizontal: 4*SizedConfig.widthMultiplier)
                                        : MediaQuery.of(context).size.width > 1000
                                          ? EdgeInsets.only(left: 4*SizedConfig.widthMultiplier,right: 2*SizedConfig.widthMultiplier)
                                          : EdgeInsets.only(left: 4*SizedConfig.widthMultiplier),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft: Radius.circular(1.5*SizedConfig.heightMultiplier)), //Check
                                        color: Colors.grey
                                    ),
                                    child:Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:EdgeInsets.only(right: isPortrait ? 5.2*SizedConfig.widthMultiplier : 4.8*SizedConfig.widthMultiplier),
                                          child: Icon(FontAwesomeIcons.list,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: courseController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Select a course",
                                              hintStyle: TextStyle(color: Colors.white,fontSize: 3.2*SizedConfig.heightMultiplier),
                                              errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier),
                                              suffixIcon: PopupMenuButton<String>(
                                                color: Colors.red,
                                                onSelected: (course){
                                                  courseController.text = course;
                                                  for(var i=0;i<this.count;i++){
                                                    if(list[i]['title'].contains(course)){
                                                      this.courseId = list[i]['id'].toString();
                                                    }
                                                  }
                                                },
                                                child: Icon(FontAwesomeIcons.chevronDown,color: Colors.white,size: 3*SizedConfig.heightMultiplier,),
                                                itemBuilder: (context) => courseList
                                                    .map<PopupMenuEntry<String>>((course) => PopupMenuItem(
                                                      value: course,
                                                      child: Text(course),
                                                      textStyle: TextStyle(
                                                        fontSize: isPortrait ? 3.2*SizedConfig.heightMultiplier : 4*SizedConfig.heightMultiplier,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                      ),
                                                      height: isPortrait ? 7*SizedConfig.heightMultiplier : 9*SizedConfig.heightMultiplier,
                                                      ))
                                                    .toList(),
                                              )
                                            ),
                                            style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                            readOnly: true,
                                            cursorColor: Colors.white,
                                            validator: (text){
                                              if(text.isEmpty){
                                                return "Enter course";
                                              }else{
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                  Container(
                                    height: isPortrait ? 9*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
                                    padding: EdgeInsets.symmetric(horizontal: 4*SizedConfig.widthMultiplier),
                                    margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft:Radius.circular(1.5*SizedConfig.heightMultiplier) ),
                                    color: Colors.grey,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                      Padding(
                                        padding:EdgeInsets.only(right: isPortrait ? 3*SizedConfig.widthMultiplier : 4.2*SizedConfig.widthMultiplier),
                                        child: Text(
                                          'LKR',
                                          style: TextStyle(fontSize: 2.8*SizedConfig.heightMultiplier,color: Colors.white),
                                        )
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                        decoration: InputDecoration(
                                        hintText: "Amount",
                                        hintStyle: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                        border: InputBorder.none,
                                        errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier)

                                        ),
                                        style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                        onSaved: setAmount,
                                        cursorColor: Colors.white,
                                        validator: (text){
                                          String statement;
                                          if(text.isEmpty){
                                            statement = "Enter amount";
                                          }else if(int.tryParse(text) == null && double.tryParse(text) == null){
                                            statement = 'Valid amount enter again';
                                          }else{
                                            statement = null;
                                          }
                                          return statement;
                                        },
                                        keyboardType: TextInputType.number,
                                        ),
                                      )
                                      ]
                                    ),
                                  ),
                                  Container(
                                    height: isPortrait ? 9*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
                                    padding: EdgeInsets.symmetric(horizontal: 4*SizedConfig.widthMultiplier),
                                    margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft:Radius.circular(1.5*SizedConfig.heightMultiplier) ),
                                      color: Colors.grey,
                                    ),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                          Padding(
                                              padding:EdgeInsets.only(right: isPortrait ? 3.8*SizedConfig.widthMultiplier : 4.5*SizedConfig.widthMultiplier),
                                              child: Text(
                                                'ref',
                                                style: TextStyle(fontSize: 3.5*SizedConfig.heightMultiplier,color: Colors.white),
                                              )
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  hintText: "Reference Number",
                                                  hintStyle: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                                  border: InputBorder.none,
                                                  errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier)

                                              ),
                                              style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                              onSaved: setRefNo,
                                              cursorColor: Colors.white,
                                              validator: (text){
                                                if(text.isEmpty){
                                                  return "Enter reference number";
                                                }else{
                                                  return null;
                                                }
                                              },
                                              keyboardType: TextInputType.number,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
                                    padding: EdgeInsets.only(top: 2*SizedConfig.heightMultiplier,left: 14*SizedConfig.widthMultiplier),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft: Radius.circular(1.5*SizedConfig.heightMultiplier)), //Check
                                      color: Colors.grey
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Note(Optional)",
                                        hintStyle: TextStyle(color: Colors.white,fontSize: 3.2*SizedConfig.heightMultiplier,),
                                        border: InputBorder.none
                                      ),
                                      maxLines: 4,
                                      style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                                      cursorColor: Colors.white,
                                      onSaved: (text){
                                        this.note = text;
                                      },
                                    ),
                                  )
                                ],
                              )
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 6*SizedConfig.widthMultiplier,
                left: 6*SizedConfig.widthMultiplier,
                bottom: 1.5*SizedConfig.heightMultiplier,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          height: 8*SizedConfig.heightMultiplier,
                          width: 40*SizedConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xff336BFF),
                          ),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 4*SizedConfig.heightMultiplier,
                                color: Colors.white,
                              ),
                              SizedBox(width: 1.5*SizedConfig.widthMultiplier),
                              Text(
                                "Go Back",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 3.5*SizedConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          Navigator.of(context).pop(CallCenter());
                        },
                      ),
                      SizedBox(width: 2*SizedConfig.widthMultiplier,),
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: 8*SizedConfig.heightMultiplier,
                          width: 40*SizedConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.green,
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 3.5*SizedConfig.heightMultiplier,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        onTap: (){
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            this.amount = double.parse(this.amount).toStringAsFixed(2);
                            submitDetails();
                          }
                        },
                      ),
                    ],
                  ),
                )
              )
            ]
        ),
    );
  }

  Future<void> submitDetails() async{
    var data = {
      'date': this.date,
      'course_id': this.courseId,
      'amount': this.amount,
      'ref_no': this.refNo,
      'note': this.note
    };

    int id = UserSimplePreferences.getId();
    var res = await NetworkRequest().postRequest(data,'/api/v1/payments/request/$id');
    var body = jsonDecode(res.body);
    if(body['status']){
      showModalBottomSheet(
        context: context,
        builder: (builder) => bottomSuccessSheet(context),
      );
    }else{
      showModalBottomSheet(
        context: context,
        builder: (builder) => bottomFailSheet(context),
      );
    }
  }

  void setAmount(String text){
    this.amount = text;
  }

  void setRefNo(String text){
    this.refNo = text;
  }

  Widget bottomSuccessSheet(BuildContext context){
    return Container(
      height: 50*SizedConfig.heightMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(3*SizedConfig.heightMultiplier),topLeft: Radius.circular(3*SizedConfig.heightMultiplier)),
          color: Colors.white
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/well_done.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5*SizedConfig.heightMultiplier,bottom: 1.5*SizedConfig.heightMultiplier),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText(
                  'Request has been submitted',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8*SizedConfig.widthMultiplier),
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomFailSheet(BuildContext context){
    return Container(
      height: 50*SizedConfig.heightMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(3*SizedConfig.heightMultiplier),topLeft: Radius.circular(3*SizedConfig.heightMultiplier)),
          color: Colors.white
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fail.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5*SizedConfig.heightMultiplier,bottom: 1.5*SizedConfig.heightMultiplier),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText(
                  'Failed to submit',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                AutoSizeText(
                  'Try again',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
