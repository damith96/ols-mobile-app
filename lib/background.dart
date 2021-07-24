import 'package:flutter/material.dart';
import 'package:test_app/size_config.dart';

class Background {

  Widget backgroundSmall(){
    return Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            bottom: 68*SizedConfig.heightMultiplier,
            left:22*SizedConfig.widthMultiplier,
            child: Container(
              height: 50*SizedConfig.heightMultiplier,
              child: Image(
                image: AssetImage("assets/images/background3.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 15*SizedConfig.heightMultiplier,
            left:-20*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -0.8,
              child: Container(
                //color: Colors.red,
                //width: 80*SizedConfig.heightMultiplier,
                height: 55*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -32*SizedConfig.heightMultiplier,
            left:28*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -1.2,
              child: Container(
                //color: Colors.red,
                height: 55*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ]
    );
  }

  Widget backgroundLarge(){
    return Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            bottom: 68*SizedConfig.heightMultiplier,
            left:22*SizedConfig.widthMultiplier,
            child: Container(
              height: 70*SizedConfig.heightMultiplier,
              child: Image(
                image: AssetImage("assets/images/background3.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 6*SizedConfig.heightMultiplier,
            left:-10*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -0.8,
              child: Container(
                //color: Colors.red,
                //width: 80*SizedConfig.heightMultiplier,
                height: 70*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50*SizedConfig.heightMultiplier,
            left:28*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -1.2,
              child: Container(
                //color: Colors.red,
                height: 70*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ]
    );
  }

  Widget backgroundUltraLarge(){
    return Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            bottom: 60*SizedConfig.heightMultiplier,
            left:35*SizedConfig.widthMultiplier,
            child: Container(
              height: 90*SizedConfig.heightMultiplier,
              child: Image(
                image: AssetImage("assets/images/background3.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: -20*SizedConfig.heightMultiplier,
            left:-20*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -1.2,
              child: Container(
                //color: Colors.red,
                //width: 80*SizedConfig.heightMultiplier,
                height: 90*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50*SizedConfig.heightMultiplier,
            left:45*SizedConfig.widthMultiplier,
            child: Transform.rotate(
              angle: -1.2,
              child: Container(
                //color: Colors.red,
                height: 80*SizedConfig.heightMultiplier,
                child: Image(
                  image: AssetImage("assets/images/background3.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ]
    );
  }

}
