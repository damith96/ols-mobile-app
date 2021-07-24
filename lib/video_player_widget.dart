import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:test_app/screens/vimeo_player.dart';
import 'package:test_app/userSimplePreferences.dart';
import 'package:video_player/video_player.dart';

import 'api.dart';
import 'size_config.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  bool isVideoPaused = true;
  int courseId;
  int lessonId;

  VideoPlayerWidget({
    Key key,
    @required this.controller,
    @required this.courseId,
    @required this.lessonId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    controller != null && controller.value.isInitialized
      ? Container(child: buildVideo())
      : Orientation.portrait == MediaQuery.of(context).orientation
          ? AspectRatio(
              aspectRatio: 16.0/9.0,
              child: Container(
                  color: Colors.black,
                  child: Center(
                    child: SizedBox(
                        width: Orientation.portrait == MediaQuery.of(context).orientation ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                        height: Orientation.portrait == MediaQuery.of(context).orientation ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                      child: CircularProgressIndicator(strokeWidth: 5.0,)
                    ),
                  ), //change the indicator size
                  //child: LinearProgressIndicator(),
                ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: SizedBox(
                    width: Orientation.portrait == MediaQuery.of(context).orientation ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                    height: Orientation.portrait == MediaQuery.of(context).orientation ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
                    child: CircularProgressIndicator(strokeWidth: 5.0,)
                ),
              ), //change the indicator size
              //child: LinearProgressIndicator(),
            );

  Widget buildVideo() => OrientationBuilder(
    builder: (context, orientation){
      final isPortrait = orientation == Orientation.portrait;
      return Stack(
        fit: isPortrait ? StackFit.loose :StackFit.expand,
        children: [
          buildVideoPlayer(),
          Positioned.fill(
              child: AdvancedOverlayWidget(
                lessonId: this.lessonId,
                courseId: this.courseId,
                controller: controller,
                onClickedFullScreen: (){
                  if(isPortrait){
                    AutoOrientation.landscapeLeftMode();
                  }else{
                    AutoOrientation.portraitUpMode();
                  }
                },
                isPortrait: isPortrait,
            )
          )
        ],
      );
    }
  );

  Widget buildVideoPlayer() => AspectRatio(
    aspectRatio: controller.value.aspectRatio,
    child: VideoPlayer(controller)
  );
}

// ignore: must_be_immutable
class AdvancedOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;
  bool isPortrait;
  static const allSpeeds = <double>[0.25,0.5,1,1.5,2];
  int courseId;
  int lessonId;

  AdvancedOverlayWidget({
    Key key,
    @required this.controller,
    this.onClickedFullScreen,
    this.isPortrait,
    @required this.courseId,
    @required this.lessonId
  }) : super(key: key);

  @override
  _AdvancedOverlayWidgetState createState() => _AdvancedOverlayWidgetState();
}

class _AdvancedOverlayWidgetState extends State<AdvancedOverlayWidget> {

  bool isVisible = true;
  bool isMuted = false;
  double currentOpacityForword = 0.0;
  double currentOpacityBackword = 0.0;
  bool requestSend = false;

  String getPosition(){
    final duration = Duration(
      milliseconds: widget.controller.value.position.inMilliseconds.round()
    );

    return [duration.inMinutes,duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2,'0'))
        .join(':');
  }

  String getDuration(){
    final duration = Duration(
        milliseconds: widget.controller.value.duration.inMilliseconds.round()
    );

    return [duration.inMinutes,duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2,'0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isVisible = !isVisible;
        });
      },
      child: Stack(
        children: [
          if(isVisible || widget.controller.value.position == widget.controller.value.duration) visibleWidgets(),
          Positioned(
            right: 0,
            bottom: widget.isPortrait ?  7*SizedConfig.heightMultiplier :  14*SizedConfig.heightMultiplier,
            top:widget.isPortrait ?  7*SizedConfig.heightMultiplier :  14*SizedConfig.heightMultiplier,
            child: GestureDetector(
              child: Container(
                width: 35*SizedConfig.widthMultiplier,
                color: Colors.transparent,
                child: AnimatedOpacity(
                    child: Icon(
                      FontAwesomeIcons.angleDoubleRight,
                      size: widget.isPortrait ? 6*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
                      color: Colors.white,
                    ),
                    duration: Duration(milliseconds: 900),
                    opacity: currentOpacityForword,
                    onEnd: () {
                      setState(() {
                        currentOpacityForword = 0.0;
                      });
                    } ,
                ),
              ),
              onDoubleTap: () {
                goForward();
                setState(() {
                  currentOpacityForword = 1.0;
                });
              },
            ),
          ),
          Positioned(
            left: 0,
            bottom: widget.isPortrait ?  7*SizedConfig.heightMultiplier :  14*SizedConfig.heightMultiplier,
            top:widget.isPortrait ?  7*SizedConfig.heightMultiplier :  14*SizedConfig.heightMultiplier,
            child: GestureDetector(
              child: Container(
                width: 35*SizedConfig.widthMultiplier,
                color: Colors.transparent,
                child: AnimatedOpacity(
                  child: Icon(
                    FontAwesomeIcons.angleDoubleLeft,
                    size: widget.isPortrait ? 6*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
                    color: Colors.white,
                  ),
                  duration: Duration(milliseconds: 900),
                  opacity: currentOpacityBackword,
                  onEnd: () {
                    setState(() {
                      currentOpacityBackword = 0.0;
                    });
                  } ,
                ),
              ),
              onDoubleTap: () {
                goBack();
                setState(() {
                  currentOpacityBackword = 1.0;
                });
              },
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: buildIndicator(),
          ),

          if(widget.controller.value.isBuffering) Center(
            child: SizedBox(
              width: widget.isPortrait ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
              height: widget.isPortrait ? 6*SizedConfig.heightMultiplier : 10*SizedConfig.heightMultiplier,
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ),
          )
        ],
      ),
    );
  }

  Future goForward() async{
    goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));
  }

  Future goBack() async{
    goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));
  }

  Future goToPosition(Duration Function(Duration currentPosition) builder) async{
    final currentPosition = await widget.controller.position;
    final newPosition = builder(currentPosition);

    await widget.controller.seekTo(newPosition);
  }

  Widget visibleWidgets() => Stack(
          children: [
            Container(
              color: Colors.black26,
            ),
            Positioned(
              top: 20,
              bottom: 20,
              right: 30,
              left: 30,
              child: Container(
                child: buildPlay(),
              ),
            ),
            Positioned(
                left: 2.5*SizedConfig.widthMultiplier,
                bottom: widget.isPortrait ? 2.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier,
                child: Text(
                  getPosition() + ' / ' + getDuration(),
                  style: TextStyle(
                      fontSize: widget.isPortrait ? 2*SizedConfig.heightMultiplier : 4*SizedConfig.heightMultiplier,
                      color: Colors.white
                  ),
                )
            ),
            buildSpeed(),
            Positioned(
              right: 2.5*SizedConfig.widthMultiplier,
              bottom: widget.isPortrait ? 2*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier,
              child: Container(
                child: Row(
                  children: [
                    GestureDetector(
                        child: isMuted
                            ? Icon(
                          Icons.volume_off,
                          color: Colors.white,
                          size: widget.isPortrait ? 4*SizedConfig.heightMultiplier : 7*SizedConfig.heightMultiplier,
                        )
                            : Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: widget.isPortrait ? 4*SizedConfig.heightMultiplier : 7*SizedConfig.heightMultiplier,
                        ),
                        onTap: () {
                          if(isMuted){
                            widget.controller.setVolume(1);
                            setState(() {
                              isMuted = ! isMuted;
                            });
                          }else{
                            widget.controller.setVolume(0);
                            setState(() {
                              isMuted = ! isMuted;
                            });
                          }
                        }
                    ),
                    SizedBox(width:2.5*SizedConfig.widthMultiplier),
                    GestureDetector(
                      child: widget.isPortrait
                          ? Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 4*SizedConfig.heightMultiplier,
                      )
                          : Icon(
                        FontAwesomeIcons.compress,
                        color: Colors.white,
                        size: 5*SizedConfig.heightMultiplier,
                      ),
                      onTap: widget.onClickedFullScreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

  Widget buildIndicator() => VideoProgressIndicator(
    widget.controller,
    allowScrubbing: true,
  );

  Widget buildSpeed() => Align(
    alignment: Alignment.topRight,
    child: PopupMenuButton<double>(
      initialValue: widget.controller.value.playbackSpeed,
      tooltip: 'Playback speed',
      onSelected: widget.controller.setPlaybackSpeed,
      itemBuilder: (context) => AdvancedOverlayWidget.allSpeeds
        .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
          value: speed,
          child: Text('${speed}x'),
          textStyle: TextStyle(
            fontSize: widget.isPortrait ? 2.5*SizedConfig.heightMultiplier : 4*SizedConfig.heightMultiplier,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
          height: widget.isPortrait ? 7*SizedConfig.heightMultiplier : 9*SizedConfig.heightMultiplier
          ))
       .toList(),
      child: Container(
        color: Colors.white70,
        padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier,horizontal: 3*SizedConfig.widthMultiplier),
        child: Text(
          '${widget.controller.value.playbackSpeed}x',
          style: TextStyle(
              fontSize: widget.isPortrait ? 2.2*SizedConfig.heightMultiplier : 4*SizedConfig.heightMultiplier,
              fontWeight: FontWeight.bold
          ),
        )
      ),
    ),
  );

  Widget buildPlay() {
    if(widget.controller.value.isPlaying && !widget.controller.value.isBuffering) {
        return IconButton(
          icon: Icon(
            Icons.pause,
            size: widget.isPortrait ? 7 * SizedConfig.heightMultiplier : 12 *
                SizedConfig.heightMultiplier,
            color: Colors.white,
          ),
          onPressed: () => widget.controller.pause(),
        );
    }else{
      if(widget.controller.value.position == widget.controller.value.duration){
        return IconButton(
          icon: Icon(
            Icons.replay,
            size: widget.isPortrait ? 7*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
            color: Colors.white,
          ),
          onPressed: () => widget.controller.initialize().then((_) => widget.controller.play())
        );
      }else if(!widget.controller.value.isBuffering){
        return IconButton(
          icon: Icon(
            Icons.play_arrow,
            size: widget.isPortrait ? 7*SizedConfig.heightMultiplier : 12*SizedConfig.heightMultiplier,
            color: Colors.white,
          ),
          onPressed: () {
            widget.controller.play();
            if(!requestSend){
              this.requestSend = true;
              putRequest();
            }
          }
        );
      }
    }
  }

  Future<void> putRequest() async{
    int id = UserSimplePreferences.getId();
    int courseId = widget.courseId;
    int lessonId = widget.lessonId;
    var response = await NetworkRequest().putData('/api/v1/courses/$id/$courseId/lessons/$lessonId/watched');
    var body = jsonDecode(response.body);
  }
}
