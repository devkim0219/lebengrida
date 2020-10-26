import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class AnimationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimationPageState();
  }
}

class _AnimationPageState extends State<AnimationPage> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      // videoPlayerController: VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
      // videoPlayerController: VideoPlayerController.asset('assets/videos/ani_5.mp4'),
      videoPlayerController: VideoPlayerController.asset('assets/videos/SampleVideo_1280x720_1mb.mp4'),
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('동화 구연'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: FlickPortraitControls(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: Colors.teal,
              child: Text(
                '문제 보기',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/question');
              },
            ),
          ],
        ),
      ),
    );
  }
}