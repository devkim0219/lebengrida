import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundation_fluttify/foundation_fluttify.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final CountDownController _countdownController = CountDownController();

  bool isStartAnswer = false;

  /**
   *  Audio Player
   */
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
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

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

  Future _playLocal() async {
    // await audioPlayer.play(localFilePath, isLocal: true);
    audioCache.play('sounds/sample1.mp3');
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

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

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }
  /**
   *  // Audio Player
   */

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Question2()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('A-1(요구)'),
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
            isStartAnswer ? countDown(5) : Container(),
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
                Text('A-1(요구) 민구는 학교에서 사용할 지우개가 다 떨어졌다. 민구는 지우개가 꼭 필요하다. 어머니에게 어떻게 했을까요?\n',
                  style: (
                    TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Text('①지우개 줄까?',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('②지우개가 필요해요',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('③지우개를 어머니에게 준다.',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('④지우개 사주세요',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
              ]
            ),
          ],
        ),
      )
    );
  }

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

class Question2 extends StatelessWidget {
  final CountDownController _countdownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('A-2(요구)'),
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
            CircularCountDownTimer(
              duration: 5,
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
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A-2(요구) 어머니는 민수에게 선물을 하기로 하였다. 민수는 신고 있는 신발을 새것으로 바꾸고 싶다. 민수는 어머니에게 “신발 사주세요”라고 말했다. 어머니는 어떻게 했을까요?\n',
                style: (
                  TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Text('①신발은 장터에서 팔아',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('②신발을 사준다.',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('③신발이 뭐야?',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('④신발을 벗어준다.',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              ]
            ),
          ],
        )
      )
    );
  }
}