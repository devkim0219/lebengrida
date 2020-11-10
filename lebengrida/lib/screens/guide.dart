import 'package:flutter/material.dart';
import 'package:lebengrida/screens/animation.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class GuidePage extends StatefulWidget {
  final String mobile;

  GuidePage({
    Key key,
    @required this.mobile,
  }) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
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

  @override
  void initState() {
    _playLocal('01_스마트 인지검사는');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('사용 방법 안내'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/'))
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text('guide page'),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.teal,
                child: Text('검사 시작', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  audioPlayer.stop();
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AnimationPage(mobile: widget.mobile),
                      )
                  );
                },
              ),
            ],
          ),
        ),
    );
  }
}
