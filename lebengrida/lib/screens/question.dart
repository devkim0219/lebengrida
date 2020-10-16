import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/models/question_data.dart';
import 'package:lebengrida/services/question_service.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final CountDownController _countdownController = CountDownController();

  List<Question> _qData;
  int i = 0;

  bool isStartAnswer = true;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText => _duration != null ? _duration.toString().split('.').first : '';
  get positionText => _position != null ? _position.toString().split('.').first : '';

  // bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  
  @override
  void initState() {
    super.initState();
    initAudioPlayer();

    _qData = [];
    _getQuestions();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  // Question ->
  // 문제 데이터 가져오기
  _getQuestions() {
    QuestionServices.getQuestions().then((questions) {
      setState(() {
        _qData = questions;
      });
      print('Length ${questions.length}');
    });
  }

  // 문제 선택지
  Widget choiceButton(int choiceNum) {
    if (choiceNum == 1) {
      
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0
      ),
      child: TextButton(
        onPressed: () => null,
        child: Text(
          _qData[0].choice_1,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  // <- Question




  // Audio Player ->
  // 오디오 플레이어 초기화
  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });

    audioPlayer.positionHandler = (d) => setState(() {
      _position = d;
    });
  }

  // 오디오 플레이어 슬라이더
  Widget slider() {
    return Slider(
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  // 오디오 플레이어 시간 찾기
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  // Future play() async {
  //   await audioPlayer.play(kUrl);
  //   setState(() {
  //     playerState = PlayerState.playing;
  //   });
  // }

  // 오디오 플레이어 로컬 파일 재생
  Future _playLocal() async {
    // await audioPlayer.play(localFilePath, isLocal: true);
    audioCache.play('sounds/sample1.mp3');
    setState(() => playerState = PlayerState.playing);
  }

  // 오디오 플레이어 일시정지
  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  // 오디오 플레이어 정지
  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      _position = Duration();
    });
  }

  // Future mute(bool muted) async {
  //   await audioPlayer.mute(muted);
  //   setState(() {
  //     isMuted = muted;
  //   });
  // }

  // 오디오 재생이 끝났을 때 플레이어 정지
  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }
  // <- Audio Player

  // 음성으로 문제 읽은 후 정답 입력 대기 카운트다운
  Widget countDown(int sec) {
    return CircularCountDownTimer(
      duration: sec,
      controller: _countdownController,
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 5,
      color: Colors.white,
      fillColor: Colors.teal,
      backgroundColor: null,
      strokeWidth: 5.0,
      textStyle: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: true,
      onComplete: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Question2()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_qData[0].type),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              child: _buildPlayer(),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _qData[0].title,
                  style: (
                    TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                // Expanded(
                //   child: AbsorbPointer(
                //     // absorbing: disableAnswer,
                //     child: Container(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           choiceButton('1'),
                //           choiceButton('2'),
                //           choiceButton('3'),
                //           choiceButton('4'),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    countDown(5),
                  ],
                ),
              ]
            ),
          ],
        ),
      )
    );
  }

  // 오디오 플레이어 생성
  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                onPressed: isPlaying ? null : () => _playLocal(),
                iconSize: 40.0,
                icon: Icon(Icons.play_arrow),
                color: Colors.cyan,
              ),
              IconButton(
                onPressed: isPlaying ? () => pause() : null,
                iconSize: 40.0,
                icon: Icon(Icons.pause),
                color: Colors.cyan,
              ),
              IconButton(
                onPressed: isPlaying || isPaused ? () => stop() : null,
                iconSize: 40.0,
                icon: Icon(Icons.stop),
                color: Colors.cyan,
              ),
            ]),
            if (_duration != null)
              slider(),
            // if (position != null) _buildMuteButtons(),
            if (_position != null) _buildProgressView()
          ],
        ),
      );

  // 오디오 플레이어 진행상태
  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            value: _position != null && _position.inMilliseconds > 0
                ? (_position?.inMilliseconds?.toDouble() ?? 0.0) /
                    (_duration?.inMilliseconds?.toDouble() ?? 0.0)
                : 0.0,
            valueColor: AlwaysStoppedAnimation(Colors.cyan),
            backgroundColor: Colors.grey.shade400,
          ),
        ),
        Text(
          _position != null
              ? "${positionText ?? ''} / ${durationText ?? ''}"
              : _duration != null ? durationText : '',
          style: TextStyle(fontSize: 24.0),
        )
      ]);

  // 오디오 플레이어 음소거 버튼
  // Row _buildMuteButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       if (!isMuted)
  //         FlatButton.icon(
  //           onPressed: () => mute(true),
  //           icon: Icon(
  //             Icons.headset_off,
  //             color: Colors.cyan,
  //           ),
  //           label: Text('Mute', style: TextStyle(color: Colors.cyan)),
  //         ),
  //       if (isMuted)
  //         FlatButton.icon(
  //           onPressed: () => mute(false),
  //           icon: Icon(Icons.headset, color: Colors.cyan),
  //           label: Text('Unmute', style: TextStyle(color: Colors.cyan)),
  //         ),
  //     ],
  //   );
  // }
}