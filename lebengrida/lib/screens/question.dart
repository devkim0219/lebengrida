import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final CountDownController _countdownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('1번 문제'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Question2()));
              },
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('문제1. 위 동물의 종류는?\n',
                  style: (
                    TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Text('① 개',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('② 고양이',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('③ 원숭이',
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                ),
                Text('④ 닭',
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
}

class Question2 extends StatelessWidget {
  final CountDownController _countdownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('2번 문제'),
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
                Text('문제2. 위 동물의 다리 수는?\n',
                style: (
                  TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Text('① 1개',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('② 2개',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('③ 3개',
                style: (
                  TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              Text('④ 4개',
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