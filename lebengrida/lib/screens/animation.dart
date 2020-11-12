import 'package:cached_video_player/cached_video_player.dart';
import 'package:cachedflickvideoplayer/cachedflickvideoplayer.dart';
import 'package:cachedflickvideoplayer/manager/flick_manager.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/screens/question.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

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

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  // 안내 음성 멘트 재생
  Future _playLocal(String filePath) async {
    // 오디오 플레이어 초기화
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    await audioCache.play('sounds/$filePath.m4a');

    audioPlayer.onPlayerCompletion.listen((event) {
      audioPlayer.stop();
    });
  }

  // 재생중인 영상 중지 후 문제 풀이 화면으로 이동
  _moveToQuestionPage() {
    audioPlayer.stop();
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuestionPage(mobile: widget.mobile),
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _playLocal('cushion_7');

    _flickManager = FlickManager(
      cachedVideoPlayerController: CachedVideoPlayerController.asset('assets/videos/animation.mp4'),
      onVideoEnd: _moveToQuestionPage,
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
    );
  }
}