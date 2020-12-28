import 'package:cached_video_player/cached_video_player.dart';
import 'package:cachedflickvideoplayer/cachedflickvideoplayer.dart';
import 'package:cachedflickvideoplayer/manager/flick_manager.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/screen/question_screen.dart';

class AnimationPage extends StatefulWidget {
  final String mobile;
  static const ASPECT_RATIO = 3 / 2;

  AnimationPage({Key key, @required this.mobile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimationPageState();
  }
}

class _AnimationPageState extends State<AnimationPage> {
  FlickManager _flickManager;

  @override
  void initState() {
    super.initState();

    _flickManager =  FlickManager(
      cachedVideoPlayerController: CachedVideoPlayerController.asset('assets/videos/animation.mp4'),
      onVideoEnd: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionPage(mobile: widget.mobile),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('동화 구연'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            FlickVideoPlayer(
              flickManager: _flickManager,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('시작'),
        icon: Icon(Icons.skip_next),
        backgroundColor: Colors.teal,
        onPressed: () {
          _flickManager.flickControlManager.pause();
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuestionPage(mobile: widget.mobile),
            )
          );
        },
      ),
    );
  }
}