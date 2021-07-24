import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:test_app/size_config.dart';

class CheckConnectivity{

  void showConnectivityBottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (builder) => bottomSheet(context),
    );
  }

  Widget bottomSheet(BuildContext context){
    SizedConfig().init(context);
    return Container(
      height: 52*SizedConfig.heightMultiplier,
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
                  image: AssetImage('assets/images/falling_down.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText('Aaaah!',style: TextStyle(fontSize: 3.8*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800),),
                AutoSizeText('Something went wrong',style: TextStyle(fontSize: 3.8*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800)),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                AutoSizeText('Brace yourself till we get the error fixed',style: TextStyle(fontSize: 2.2*SizedConfig.heightMultiplier,fontWeight: FontWeight.w400)),
                AutoSizeText('You may try again',style: TextStyle(fontSize: 2.2*SizedConfig.heightMultiplier,fontWeight: FontWeight.w400)),
                AutoSizeText('or',style: TextStyle(fontSize: 2.2*SizedConfig.heightMultiplier,fontWeight: FontWeight.w400)),
                AutoSizeText('check your network connection',style: TextStyle(fontSize: 2.2*SizedConfig.heightMultiplier,fontWeight: FontWeight.w400)),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8*SizedConfig.widthMultiplier,vertical: 1.5*SizedConfig.heightMultiplier),
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 2.4*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
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