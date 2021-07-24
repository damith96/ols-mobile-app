import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/screens/home_page.dart';
import 'package:test_app/screens/submit_payment.dart';
import 'package:url_launcher/url_launcher.dart';

import '../background.dart';
import '../size_config.dart';

class CallCenter extends StatelessWidget {

  final String phoneNo = '0778891575';

  Future customLaunch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print(' could not launch $url');
    }
  }
  
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
                child: Container(

                  child: Card(
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
                              "CALL CENTER",
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
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    6.8*SizedConfig.widthMultiplier,35*SizedConfig.heightMultiplier,
                    6.8*SizedConfig.widthMultiplier,13*SizedConfig.heightMultiplier),
                child: ListView(
                  children: [
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 5*SizedConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                          color: Colors.grey[300],
                        ),
                        child: Text(
                            "Call Instructor",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 4.5*SizedConfig.heightMultiplier,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                      ),
                      onTap: (){
                        customLaunch('tel:$phoneNo');
                      },
                    ),
                    SizedBox(height: 4.5*SizedConfig.heightMultiplier,),
                    box(context),
                    SizedBox(height: 4.5*SizedConfig.heightMultiplier,),
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 5*SizedConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                          color: Colors.grey[300],
                        ),
                        child: Text(
                          "Whatsapp",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 4.5*SizedConfig.heightMultiplier,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      onTap: (){
                        customLaunch('whatsapp://chat/?code=BsOqo1iv0355vMrR7mPfMv');
                        // customLaunch('https://chat.whatsapp.com/BsOqo1iv0355vMrR7mPfMv');
                      },
                    ),
                  ],
                ),
              ),
              //Go back button
              Positioned(
                bottom:1.5*SizedConfig.heightMultiplier,
                right: 6.8*SizedConfig.widthMultiplier,
                left: 6.8*SizedConfig.widthMultiplier,
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
                    Navigator.of(context).pop(HomePage());
                  },
                ),
              )
            ]
        )
    );
  }

  Widget box(BuildContext context){
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5*SizedConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2*SizedConfig.heightMultiplier),
          color: Colors.grey[300],
        ),
        child: Text(
          "Submit Payment",
          style: TextStyle(
              color: Colors.black,
              fontSize: 4.5*SizedConfig.heightMultiplier,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context){
              return SubmitPayment();
            }
        ));
      },
    );
  }
}
