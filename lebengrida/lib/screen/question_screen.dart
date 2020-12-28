import 'dart:io' as io;
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:date_format/date_format.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lebengrida/data/login_auth.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/model/question_data.dart';
import 'package:lebengrida/screen/result_screen.dart';
import 'package:lebengrida/service/question_service.dart';
import 'package:lebengrida/service/result_service.dart';
import 'package:lebengrida/service/user_service.dart';
import 'package:lebengrida/service/fileupload_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

  bool _isShowQuestion = false;
  bool _isStartAnswer = false;
  int _selectedAnswer = 0;
  int _correctAnswer = 0;
  List<int> _scoreList = [];
  int _currentIdx = 0;

  List<Question> _qData = [];
  int _qIdx = 0;
  String _selectText = '';
  int _attempt = 1;

  bool _isRecording = false;
  bool _ignoreTouch = false;
  bool _isSkipRecording = false;

  File uploadAudioFile;
  TextEditingController _controller = TextEditingController();

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  bool _isSkipAudio = false;
  Key _countdownKey;
  Key _bodyKey;

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
      print('question length : ${questions.length}');
    });
  }

  // 문제 선택지
  Widget selectButton(int selNum) {
    if (selNum == 1) {
      _selectText = '$selNum. ' + (_qData.length > 0 ? _qData[_qIdx].select_1 : '');
    } else if (selNum == 2) {
      _selectText = '$selNum. ' + (_qData.length > 0 ? _qData[_qIdx].select_2 : '');
    } else if (selNum == 3) {
      _selectText = '$selNum. ' + (_qData.length > 0 ? _qData[_qIdx].select_3 : '');
    } else {
      _selectText = '$selNum. ' + (_qData.length > 0 ? _qData[_qIdx].select_4 : '');
    }

    return SizedBox(
      width: double.infinity,
      child: IgnorePointer(
        ignoring: _ignoreTouch,
        child: TextButton(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(_selectText),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black87,
            backgroundColor: Colors.teal[100],
            textStyle: TextStyle(
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          onPressed: () {
            setState(() {
              if (_isRecording) {
                AudioRecorder.stop();
              }
              _selectedAnswer = selNum;
              _correctAnswer =  int.parse(_qData[_qIdx].answer);
              print('selected answer -> $_selectedAnswer');
              print('correct answer -> ${_qData[_qIdx].answer}');

              // 선택지 선택 시(터치 or 음성) 다음 문제로 전환
              // 1~19 문제
              if (_selectedAnswer > 0 && _qIdx < _qData.length - 1) {
                _isStartAnswer = false;
                _qIdx++;
                // 1차 시도
                if (_attempt == 1) {
                  // 정답
                  if (_correctAnswer == _selectedAnswer) {
                    _scoreList.add(2);
                    // 오답
                  } else {
                    _scoreList.add(0);
                  }
                  // 2차 시도
                } else {
                  // 정답
                  if (_correctAnswer == _selectedAnswer) {
                    _scoreList.add(1);
                    // 오답
                  } else {
                    _scoreList.add(0);
                  }
                }
                _attempt = 1;
                print('selected answer.. index -> $_qIdx, attempt -> $_attempt');
                print('score list -> $_scoreList');
                audioPlayer.stop();
                _playQuestionAudio();
                _selectedAnswer = 0;
                // 마지막 문제
              } else {
                _qIdx = 0;
                // 1차 시도
                if (_attempt == 1) {
                  // 정답
                  if (_correctAnswer == _selectedAnswer) {
                    _scoreList.add(2);
                    // 오답
                  } else {
                    _scoreList.add(0);
                  }
                  // 2차 시도
                } else {
                  // 정답
                  if (_correctAnswer == _selectedAnswer) {
                    _scoreList.add(1);
                    // 오답
                  } else {
                    _scoreList.add(0);
                  }
                }
                print('selected answer.. index -> $_qIdx, attempt -> $_attempt');
                print('score list -> $_scoreList');
                audioPlayer.stop();
                _playEndingAudio();
                _saveTestResult(widget.mobile, _scoreList);
              }
            });
          },
        ),
      ),
    );
  }

  // 문제 생성
  Widget _makeQuestion() {
    if (_isShowQuestion) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문제를 다 들은 후 5초 안에 정답을 말하거나 터치하세요.',
            // '문제를 다 들은 후 5초 안에 정답을 말하거나 터치하세요.\n음성 인식 중에는 터치가 지원되지 않습니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 20),
          Text(
            _qData.length > 0 ? _qData[_qIdx].title : '',
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          selectButton(1),
          SizedBox(height: 3),
          selectButton(2),
          SizedBox(height: 3),
          selectButton(3),
          SizedBox(height: 3),
          selectButton(4),
          SizedBox(height: 20),
          // 문제 음성 파일 재생 완료 후 카운트다운 시작
          _isStartAnswer ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: _countDown(5),
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
        ],
      );
    } else {
      return Text(
        '안내 음성이 끝난 후 문제가 나옵니다.',
        style: TextStyle(
          fontSize: 20,
          color: Colors.redAccent,
        ),
      );
    }
  }
  // <- Question

  // Audio Player ->
  // 오디오 플레이어 초기화
  void _initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });
    audioPlayer.positionHandler = (d) => setState(() {
      _position = d;
    });
  }

  // 랜덤 문자열 키 생성
  String _generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  // 문제 음성 재생
  Future _playQuestionAudio() async {
    _countdownKey = new Key(_generateRandomString(5));
    _bodyKey = new Key(_generateRandomString(5));

    _initAudioPlayer();
    await audioCache.play('sounds/question_${_qIdx + 1}.m4a');

    setState(() {
      _ignoreTouch = false;
      Future.delayed(Duration(seconds: 2), () => _controller.text = '');
      if (!_isSkipAudio) {
        playerState = PlayerState.playing;
      } else {
        audioPlayer.stop();
      }
    });

    if (_isSkipAudio) {
      _startRecord();
    }

    audioPlayer.onPlayerCompletion.listen((event) {
      // _ignoreTouch = true;
      if (!_isRecording) {
        _startRecord();
      }
      setState(() {
        _currentIdx = _qIdx;
        _isStartAnswer = true;
        _controller.text = '';
      });
    });
  }

  // 안내 음성 멘트 재생
  var _idx = 8;
  Future _playGuideAudio() async {
    _initAudioPlayer();
    await audioCache.play('sounds/cushion_$_idx.m4a');

    audioPlayer.onPlayerCompletion.listen((event) {
      _idx++;
      if (_idx >= 8 && _idx <= 11) {
        _playGuideAudio();
      } else {
        setState(() {
          _isShowQuestion = true;
        });
        _playQuestionAudio();
      }
    });
  }

  // 2차 문제 음성 재생
  Future _play2ndQuestionAudio() async {
    _initAudioPlayer();
    await audioCache.play('sounds/cushion_12.m4a');

    audioPlayer.onPlayerCompletion.listen((event) {
      _playQuestionAudio();
    });
  }

  // 검사 종료 안내 음성 재생
  Future _playEndingAudio() async {
    _initAudioPlayer();
    await audioCache.play('sounds/cushion_13.m4a');

    audioPlayer.onPlayerCompletion.listen((event) {
      audioPlayer.stop();
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
  // Widget _buildPlayer() => Container(
  //   padding: EdgeInsets.all(16.0),
  //   child: Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Row(mainAxisSize: MainAxisSize.min, children: [
  //         IconButton(
  //           onPressed: isPlaying ? null : () => _playLocal(),
  //           iconSize: 30.0,
  //           icon: Icon(Icons.play_arrow),
  //           color: Colors.cyan,
  //         ),
  //         IconButton(
  //           onPressed: isPlaying ? () => pause() : null,
  //           iconSize: 30.0,
  //           icon: Icon(Icons.pause),
  //           color: Colors.cyan,
  //         ),
  //         IconButton(
  //           onPressed: isPlaying || isPaused ? () => stop() : null,
  //           iconSize: 30.0,
  //           icon: Icon(Icons.stop),
  //           color: Colors.cyan,
  //         ),
  //       ]),
  //       if (_duration != null) _slider(),
  //       // if (position != null) _buildMuteButtons(),
  //       if (_position != null) _buildProgressView(),
  //     ],
  //   ),
  // );

  // 오디오 플레이어 슬라이더
  // Widget _slider() {
  //   return Slider(
  //     value: _position.inSeconds.toDouble(),
  //     min: 0.0,
  //     max: _duration.inSeconds.toDouble(),
  //     onChanged: (double value) {
  //       setState(() {
  //         seekToSecond(value.toInt());
  //         value = value;
  //       });
  //     },
  //   );
  // }

  // 오디오 플레이어 시간 찾기
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  // 오디오 플레이어 진행상태
  // Row _buildProgressView() => Row(
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     Padding(
  //       padding: EdgeInsets.all(12.0),
  //       child: CircularProgressIndicator(
  //         value: _position != null && _position.inMilliseconds > 0
  //             ? (_position?.inMilliseconds?.toDouble() ?? 0.0) /
  //                 (_duration?.inMilliseconds?.toDouble() ?? 0.0)
  //             : 0.0,
  //         valueColor: AlwaysStoppedAnimation(Colors.teal),
  //         backgroundColor: Colors.grey.shade400,
  //       ),
  //     ),
  //     Text(
  //       _position != null
  //           ? "${positionText ?? ''} / ${durationText ?? ''}"
  //           : _duration != null ? durationText : '',
  //       style: TextStyle(fontSize: 20.0),
  //     )
  //   ]
  // );

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
  Widget _countDown(int sec) {
    return TimeCircularCountdown(
      key: _countdownKey,
      unit: CountdownUnit.second,
      countdownTotal: sec,
      diameter: 60,
      countdownCurrentColor: Colors.teal,
      countdownTotalColor: Colors.teal,
      countdownRemainingColor: Colors.teal[100],
      onUpdated: (unit, remainTime) {
        // setState(() {
        //   if (remainTime == 1) {
        //     Fluttertoast.showToast(
        //       msg: '음성 인식 중입니다..',
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.BOTTOM,
        //       timeInSecForIosWeb: 3
        //     );
        //   }
        // });
      },
      onFinished: () {
        if (_isRecording) {
          Fluttertoast.showToast(
              msg: '음성 인식 중입니다..',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3
          );
          _stopRecord();
        }
      },
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
      ),
    );
  }

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
    // 60~69세 : 30점, 70~74세 : 30점, 75~79세 : 29점, 80세 이상 : 28점
    if (int.parse(_user.age) <= 74 && _totalPoint >= 30 ||
        int.parse(_user.age) >= 75 && int.parse(_user.age) <= 79 && _totalPoint >= 29 ||
        int.parse(_user.age) >= 80 && _totalPoint >= 28 ) {
      _resultStatus = 'pass';
    } else {
      _resultStatus = 'nopass';
    }

    ResultServices.saveTestResult(mobile, answerList, _totalPoint, _resultStatus).then((result) {
      if ('success' == result) {
        Provider.of<LoginAuth>(context, listen: false).setTestDate(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
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
      String fileName = 'answer_${_qIdx + 1}_${_attempt}_${DateTime.now().toUtc().millisecondsSinceEpoch}';
      io.Directory externalStorageDirectory = await getExternalStorageDirectory();
      String path = externalStorageDirectory.path + '/' + fileName;
      print('Start recording -> $path');

      await AudioRecorder.start(
        path: path,
        audioOutputFormat: AudioOutputFormat.WAV,
      );
      bool isRecording = await AudioRecorder.isRecording;
      _isRecording = isRecording;
      // if (_isRecording) {
      //   Future.delayed(Duration(seconds: 5), () {
      //     _stopRecord();
      //   });
      // }
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
    FileUploadServices.uploadAudioFile(widget.mobile, (_currentIdx + 1).toString(), recording.path).then((result) {
      print('response body -> $result');

      // string parse to integer
      var _result = int.parse(result);
      _controller.text = result;

      // 음성 인식 서버 리턴 값에 따른 로직 처리
      // 답을 선택했을 경우
      if (_result >= 1 && _result <= 4) {
        _isSkipAudio = false;
        _correctAnswer = int.parse(_qData[_qIdx].answer);

        // 1~19 문제
        if (_qIdx < _qData.length - 1) {
          _isStartAnswer = false;
          _qIdx++;
          // 1차 시도
          if (_attempt == 1) {
            // 정답
            if (_correctAnswer == _result) {
              _scoreList.add(2);
              // 오답
            } else {
              _scoreList.add(0);
            }
            // 2차 시도
          } else {
            // 정답
            if (_correctAnswer == _result) {
              _scoreList.add(1);
              // 오답
            } else {
              _scoreList.add(0);
            }
          }
          _attempt = 1;
          print('stt return answer.. index -> $_qIdx, attempt -> $_attempt');
          print('score list -> $_scoreList');
          audioPlayer.stop();
          _playQuestionAudio();

          // 마지막 문제
        } else {
          _qIdx = 0;
          // 1차 시도
          if (_attempt == 1) {
            // 정답
            if (_correctAnswer == _result) {
              _scoreList.add(2);
              // 오답
            } else {
              _scoreList.add(0);
            }
            // 2차 시도
          } else {
            // 정답
            if (_correctAnswer == _result) {
              _scoreList.add(1);
              // 오답
            } else {
              _scoreList.add(0);
            }
          }
          print('stt return answer.. index -> $_qIdx, attempt -> $_attempt');
          print('stt return answer list -> $_scoreList');
          audioPlayer.stop();
          _playEndingAudio();
          _saveTestResult(widget.mobile, _scoreList);
        }

        // 음성이 불분명할 경우 재요청(계속)
      } else if (_result == 0) {
        Fluttertoast.showToast(
            msg: '다시 한 번 마이크에 대고 말해주세요.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3
        );
        _isSkipAudio = true;
        audioPlayer.stop();
        _playQuestionAudio();

        // 입력받은 음성이 없을 경우(null) 재요청(2차) -> _result == 9
      } else {
        _isSkipAudio = false;
        _isStartAnswer = false;
        // 1~19번 문제
        if (_qIdx < _qData.length - 1) {
          // 2차 시도
          if (_attempt == 2) {
            _scoreList.add(0);
            _qIdx++;
            _attempt = 1;
            audioPlayer.stop();
            _playQuestionAudio();
          } else {
            _attempt = 2;
            audioPlayer.stop();
            _play2ndQuestionAudio();
          }

          // 마지막 문제
        } else {
          // 1차 시도
          if (_attempt == 1) {
            _attempt = 2;
            audioPlayer.stop();
            _play2ndQuestionAudio();
            // 2차 시도
          } else {
            _scoreList.add(0);
            _attempt = 1;
            audioPlayer.stop();
            _playEndingAudio();
            _saveTestResult(widget.mobile, _scoreList);
          }
        }
      }
    });
    _isRecording = isRecording;
  }
  // <- Audio Record

  @override
  void initState() {
    super.initState();
    _getQuestions();
    isPlaying ? 'null' : _playGuideAudio();
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
          _qData.length > 0 ? '${_qIdx + 1}. ${_qData[_qIdx].type}' : '',
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        key: _bodyKey,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // _buildPlayer(),
            // Text(
            //   'now playing.. question_${_qIdx + 1}.m4a\nattempt : $_attempt',
            // ),
            SizedBox(height: 10),
            _makeQuestion(),
            SizedBox(height: 20),
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
                // Text('File path of the record: ${_recording.path}'),
                // Text('Format: ${_recording.audioOutputFormat}'),
                // Text('Extension: ${_recording.extension}'),
                // Text('Audio recording duration: ${_recording.duration.toString()}'),
                // SizedBox(height: 20),
                Text('결과 값 테스트용(하단 부분 삭제 예정)'),
                Text('음성 인식 결과 :'),
                TextField(
                  controller: _controller,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: '1~4: 선택한 답, 0: 인식 불분명, 9: 무응답',
                  ),
                ),
                SizedBox(height: 20),
                Text('question no. : ${_qIdx + 1}, attempt : $_attempt'),
                Text('score list : $_scoreList'),
                // Text('_isSkipAudio : $_isSkipAudio'),
                // Text('_isStartAnswer : $_isStartAnswer'),
                // Text('countdown key : $_countdownKey'),
                // Text('body key : $_bodyKey'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}