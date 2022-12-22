import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
//import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '../../constant/MyAppColor.dart';


/*
*
* video integration plugin url  https://pub.dev/packages/flick_video_player
*
* */

class VideoViewScreen extends StatefulWidget {
  //SamplePlayer({Key? key}) : super(key: key);
  const VideoViewScreen({Key? key, required this.video_path}) : super(key: key);
  final String video_path;

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    print('video_path ${widget.video_path}');
    flickManager = FlickManager(
      videoPlayerController:VideoPlayerController.network(widget.video_path),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('',style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: Center(
        child: Container(
          height: 300,
          child: FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              closedCaptionTextStyle: TextStyle(fontSize: 8),
              controls: FlickPortraitControls(),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              controls: FlickLandscapeControls(),
            ),
          ),
        ),
      ),
    );
  }
}