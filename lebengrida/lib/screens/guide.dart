import 'package:carousel_widget/carousel_widget.dart';
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

  List<String> titles = List();
  List<String> description = List();
  List<String> imageNames = List();

  int _idx = 1;

  // 안내 음성 멘트 재생
  Future _playLocal(String filePath) async {
    // 오디오 플레이어 초기화
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    await audioCache.play('sounds/$filePath.m4a');

    audioPlayer.onPlayerCompletion.listen((event) {
      _idx++;

      if (_idx >= 1 && _idx <= 6) {
        _playLocal('cushion_$_idx');
      } else {
        audioPlayer.stop();
      }
    });
  }

  // 슬라이드 이미지 초기화
  void initializeData() {
    // login.png
    titles.add('로그인');
    description.add('1. 휴대폰 번호 입력\n2. 로그인 버튼 터치');
    imageNames.add('assets/images/login.png');

    // animation.png
    titles.add('동화 구연');
    description.add('1. 일시정지\n2. 일시정지 및 음소거\n3. 전체화면');
    imageNames.add('assets/images/animation.png');

    // question.png
    titles.add('화행 검사 문제');
    description.add('1. 문제(16문항)\n2. 터치 또는 음성으로 선택가능\n3. 5초 이내에 음성 입력\n    (1차에 입력 없을시 2차 진행)');
    imageNames.add('assets/images/question.png');

    // result.png
    titles.add('검사 결과');
    description.add('1. 1차: 2점, 2차: 1점, 오답: 0점\n    (총점 32점)\n2. 연령대와 총점에 따라 인지 능력 저하\n    판단');
    imageNames.add('assets/images/result.png');
  }

  // 이미지 출력
  Widget getScreen(index) {
    return ListView(
      children: <Widget>[
        Container(
          height: 250.0,
          margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
          child: Image.asset(imageNames.elementAt(index)),
        ),
        Container(
          height: 35.0,
          margin: EdgeInsets.fromLTRB(30.0, 45.0, 30.0, 0.0),
          child: Text(
            titles.elementAt(index),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 150.0,
          margin: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 0.0),
          child: Text(
            description.elementAt(index),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _playLocal('cushion_1');
    initializeData();
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
          ),
        ],
      ),
      body: Carousel(
        listViews: [
          Fragment(child: getScreen(0)),
          Fragment(child: getScreen(1)),
          Fragment(child: getScreen(2)),
          Fragment(child: getScreen(3)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('시작'),
        icon: Icon(Icons.skip_next),
        backgroundColor: Colors.teal,
        onPressed: () {
          audioPlayer.stop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnimationPage(mobile: widget.mobile),
            )
          );
        },
      ),
    );
  }
}
