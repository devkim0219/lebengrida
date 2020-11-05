import 'dart:io' as io;
import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lebengrida/models/user_data.dart';
import 'package:lebengrida/screens/result.dart';
import 'package:lebengrida/models/question_data.dart';
import 'package:lebengrida/services/question_service.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:lebengrida/services/result_service.dart';
import 'package:lebengrida/services/user_service.dart';
import 'package:lebengrida/services/fileupload_service.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class QuestionPage extends StatefulWidget {
  final String mobile;
  final LocalFileSystem localFileSystem = LocalFileSystem();

  QuestionPage({Key key, @required this.mobile, localFileSystem}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  User _user;

  bool _isStartAnswer = false;
  int _selectedAnswer = 0;
  int _correctAnswer = 0;
  List<int> _answerList = [];

  List<Question> _qData = [];
  int _qIdx = 0;
  String _selectText = '';
  int _attempt = 1;

  Recording _recording = new Recording();
  bool _isRecording = false;

  File uploadAudioFile;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText => _duration != null ? _duration.toString().split('.').first : '';
  get positionText => _position != null ? _position.toString().split('.').first : '';

  // bool isMuted = false;
  
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
  Widget selectButton(int selNum) {
    if (selNum == 1) {
      _selectText = '$selNum. ' + _qData[_qIdx].select_1;
    } else if (selNum == 2) {
      _selectText = '$selNum. ' + _qData[_qIdx].select_2;
    } else if (selNum == 3) {
      _selectText = '$selNum. ' + _qData[_qIdx].select_3;
    } else {
      _selectText = '$selNum. ' + _qData[_qIdx].select_4;
    }

    return TextButton(
      child: Text(
        _selectText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedAnswer = selNum;
          _correctAnswer =  int.parse(_qData[_qIdx].answer);
          print('selected answer -> $_selectedAnswer');
          print('correct answer -> ${_qData[_qIdx].answer}');

          // 선택지 선택 시(터치 or 음성) 다음 문제로 전환
          // 1~15 문제
          if (_selectedAnswer > 0 && _qIdx < 15) {
            _isStartAnswer = false;
            _qIdx++;
            // 1차 시도
            if (_attempt == 1) {
              // 정답
              if (_correctAnswer == _selectedAnswer) {
                _answerList.add(2);
              // 오답
              } else {
                _answerList.add(0);
              }
            // 2차 시도
            } else {
              // 정답
              if (_correctAnswer == _selectedAnswer) {
                _answerList.add(1);
              // 오답
              } else {
                _answerList.add(0);
              }
            }
            _attempt = 1;
            print('selected answer.. index -> $_qIdx, attempt -> $_attempt');
            print('selected answer list -> $_answerList');
            audioPlayer.stop();
            _playLocal();
            _selectedAnswer = 0;
          // 마지막 문제
          } else {
            _qIdx = 0;
            // 1차 시도
            if (_attempt == 1) {
              // 정답
              if (_correctAnswer == _selectedAnswer) {
                _answerList.add(2);
              // 오답
              } else {
                _answerList.add(0);
              }
            // 2차 시도
            } else {
              // 정답
              if (_correctAnswer == _selectedAnswer) {
                _answerList.add(1);
              // 오답
              } else {
                _answerList.add(0);
              }
            }
            print('selected answer.. index -> $_qIdx, attempt -> $_attempt');
            print('selected answer list -> $_answerList');
            audioPlayer.stop();
            _saveTestResult(widget.mobile, _answerList);
          }
        });
      },
    );
  }

  // 문제 생성
  Widget _makeQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '문제를 다 들은 후 5초 안에 정답을 말하거나 터치하세요.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 20),
        Text(
          _qData[_qIdx].title,
          style: (
            TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        SizedBox(
          height: 10,
        ),
        selectButton(1),
        selectButton(2),
        selectButton(3),
        selectButton(4),
        SizedBox(
          height: 20,
        ),
        // 문제 음성 파일 재생 완료 후 카운트다운 시작
        _isStartAnswer ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: countDown(5),
            ),
            SizedBox(height: 10),
            Text(
              '마이크에 대고 정답을 말하세요.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
              ),
            ),
          ],
        ) : Container(),
      ]
    );
  }
  // <- Question

  // Audio Player ->
  // 오디오 플레이어 초기화
  // void initAudioPlayer() {
  //   audioPlayer = new AudioPlayer();
  //   audioCache = new AudioCache(fixedPlayer: audioPlayer);
  //
  //   audioPlayer.durationHandler = (d) => setState(() {
  //     _duration = d;
  //   });
  //   audioPlayer.positionHandler = (d) => setState(() {
  //     _position = d;
  //   });
  // }

  // Future play() async {
  //   await audioPlayer.play(kUrl);
  //   setState(() {
  //     playerState = PlayerState.playing;
  //   });
  // }

  // 오디오 플레이어 로컬 파일 재생
  Future _playLocal() async {
    // 오디오 플레이어 초기화
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });
    audioPlayer.positionHandler = (d) => setState(() {
      _position = d;
    });

    // await audioPlayer.play(localFilePath, isLocal: true);
    await audioCache.play('sounds/question_${_qIdx + 1}.m4a');
    setState(() => playerState = PlayerState.playing);

    // audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) => {
    //   if (s == AudioPlayerState.COMPLETED) {
    //     _startRecord()
    //   }
    // });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        if (!_isRecording) {
          _startRecord();
        }
        _isStartAnswer = true;
      });
    });
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

  // 오디오 플레이어 음소거
  // Future mute(bool muted) async {
  //   await audioPlayer.mute(muted);
  //   setState(() {
  //     isMuted = muted;
  //   });
  // }

  // 오디오 재생이 끝났을 때 플레이어 정지
  void onComplete() {
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  // 오디오 플레이어 생성
  Widget _buildPlayer() => Container(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row(mainAxisSize: MainAxisSize.min, children: [
        //   IconButton(
        //     onPressed: isPlaying ? null : () => _playLocal(),
        //     iconSize: 30.0,
        //     icon: Icon(Icons.play_arrow),
        //     color: Colors.cyan,
        //   ),
        //   IconButton(
        //     onPressed: isPlaying ? () => pause() : null,
        //     iconSize: 30.0,
        //     icon: Icon(Icons.pause),
        //     color: Colors.cyan,
        //   ),
        //   IconButton(
        //     onPressed: isPlaying || isPaused ? () => stop() : null,
        //     iconSize: 30.0,
        //     icon: Icon(Icons.stop),
        //     color: Colors.cyan,
        //   ),
        // ]),
        if (_duration != null) _slider(),
        // if (position != null) _buildMuteButtons(),
        if (_position != null) _buildProgressView(),
      ],
    ),
  );

  // 오디오 플레이어 슬라이더
  Widget _slider() {
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

  // 오디오 플레이어 진행상태
  Row _buildProgressView() => Row(
    mainAxisSize: MainAxisSize.min, 
    children: [
      Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(
          value: _position != null && _position.inMilliseconds > 0
              ? (_position?.inMilliseconds?.toDouble() ?? 0.0) /
                  (_duration?.inMilliseconds?.toDouble() ?? 0.0)
              : 0.0,
          valueColor: AlwaysStoppedAnimation(Colors.teal),
          backgroundColor: Colors.grey.shade400,
        ),
      ),
      Text(
        _position != null
            ? "${positionText ?? ''} / ${durationText ?? ''}"
            : _duration != null ? durationText : '',
        style: TextStyle(fontSize: 20.0),
      )
    ]
  );

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
  // <- Audio Player

  // 음성으로 문제 읽은 후 정답 입력 대기 카운트다운
  // 카운트다운과 동시에 정답 음성 입력 받음
  Widget countDown(int sec) {
    return TimeCircularCountdown(
      unit: CountdownUnit.second,
      countdownTotal: sec,
      diameter: 60,
      countdownCurrentColor: Colors.teal,
      countdownTotalColor: Colors.teal,
      countdownRemainingColor: Colors.teal[100],
      onUpdated: (unit, remainTime) {
        setState(() { });
      },
      onFinished: () {
        setState(() {
          //카운트다운 5초 후(2차) 자동으로 다음 문제로 전환
          // 1~15 문제
          if (_qIdx < 15) {
            _isStartAnswer = false;
            // 2차 시도
            if (_attempt == 2) {
              _qIdx++;
              _attempt = 1;
              _answerList.add(0);
            // 1차 시도
            } else {
              _attempt = 2;
            }
            // audioPlayer.stop();
            // 2차 문제 음성 출력
            _playLocal();
            print('selected answer list -> $_answerList');
            print('countdown complete.. -> index is $_qIdx, attempt is $_attempt');
          // 마지막 문제
          } else if (_qIdx == 15) {
            _isStartAnswer = false;
            // 1차 시도
            if (_attempt == 1) {
              // audioPlayer.stop();
              // 2차 문제 음성 출력
              _playLocal();
              _attempt = 2;
            // 2차 시도
            } else {
              _attempt = 1;
              _qIdx = 0;
              _answerList.add(0);
              print('selected answer list -> $_answerList');
              print('countdown complete.. -> index is $_qIdx, attempt is $_attempt');
              _saveTestResult(widget.mobile, _answerList);
            }
          } else {}
        });
      },
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
      ),
    );
  }

  // 카운트다운 시간 표시 형식
  // String _formatTime(CountdownUnit unit, int remainingTime) =>
  //     '$remainingTime ${describeEnum(unit)}${remainingTime > 1 ? 's' : ''}';

  // 검사 결과 저장
  _saveTestResult(String mobile, List<int> answerList) {
    String _msg = '';
    String _resultStatus = '';
    int _totalPoint = 0;

    // 총점
    for (var i = 0; i < answerList.length; i++) {
        _totalPoint += answerList[i];
    }

    // 인지 능력 저하 판단
    // 60~69세 : 22점, 70~74세 : 22점, 75~79세 : 21점, 80세 이상 : 20점
    if (int.parse(_user.age) >= 60 && int.parse(_user.age) <= 74 && _totalPoint >= 22 ||
        int.parse(_user.age) >= 75 && int.parse(_user.age) <= 79 && _totalPoint >= 21 ||
        int.parse(_user.age) >= 80 && _totalPoint >= 20 ) {
      _resultStatus = 'pass';
    } else {
      _resultStatus = 'nopass';
    }

    ResultServices.saveTestResult(mobile, answerList, _totalPoint, _resultStatus)
      .then((result) {
        if ('success' == result) {
          _msg = '검사 결과가 저장되었습니다.';
        } else {
          _msg = '오류로 인해 검사 결과가 저장되지 않았습니다.';
        }
        Fluttertoast.showToast(
          msg: _msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      });
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(mobile: widget.mobile),
      )
    );
  }

  // -> Audio Record
  // 오디오 녹음 시작
  _startRecord() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        String fileName = 'answer_${_qIdx + 1}_${_attempt}_${DateTime.now().toUtc().millisecondsSinceEpoch}';
        // String path = 'answer_${_qIdx + 1}_$_attempt';
        io.Directory externalStorageDirectory = await getExternalStorageDirectory();
        String path = externalStorageDirectory.path + '/' + fileName;
        print('Start recording -> $path');
        await AudioRecorder.start(
          path: path,
          audioOutputFormat: AudioOutputFormat.AAC,
        );
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: '');
          _isRecording = isRecording;
          if (_isRecording) {
            Future.delayed(Duration(seconds: 5), () {
              _stopRecord();
            });
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: '마이크 권한 설정이 필요합니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    } catch(e) {
      print(e);
    }
  }

  // 오디오 녹음 정지
  _stopRecord() async {
    var recording = await AudioRecorder.stop();
    print('Stop recording: ${recording.path}');
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print('File length: ${await file.length()}');

    // 서버로 파일 업로드
    // FileUploadServices.uploadAudioFile(file, recording.path, widget.mobile, _qIdx + 1, _qData[_qIdx].answer);
    FileUploadServices.uploadAudioFile(widget.mobile, (_qIdx + 1).toString(), file, recording.path);

    // http패키지 MultipartRequest class

    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
  }
  // <- Audio Record

  @override
  void initState() {
    super.initState();
    _getQuestions();
    // initAudioPlayer();
    isPlaying ? null : _playLocal();
    
    UserServices.getUserInfo(widget.mobile).then((value) {
      _user = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          '${_qIdx + 1}. ${_qData[_qIdx].type}',
          softWrap: true,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // _buildPlayer(),
            // Text(
            //   'now playing.. question_${_qIdx + 1}.m4a\nattempt : $_attempt',
            // ),
            SizedBox(
              height: 10,
            ),
            _makeQuestion(),
            SizedBox(
              height: 20,
            ),
            // Text(
            //   '오디오 레코드 테스트'
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Row(
                //   children: [
                //     FlatButton(
                //       onPressed: _isRecording ? null : _startRecord,
                //       child: Text('Start'),
                //       color: Colors.green,
                //     ),
                //     FlatButton(
                //       onPressed: _isRecording ? _stopRecord : null,
                //       child: Text('Stop'),
                //       color: Colors.red,
                //     ),
                //   ],
                // ),
                Text('File path of the record: ${_recording.path}'),
                Text('Format: ${_recording.audioOutputFormat}'),
                Text('Extension: ${_recording.extension}'),
                Text('Audio recording duration: ${_recording.duration.toString()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}