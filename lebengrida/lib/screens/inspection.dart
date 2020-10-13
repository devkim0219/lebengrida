import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<String> imgList = [
  'assets/images/dog_1.png',
  'assets/images/dog_2.png',
  'assets/images/dog_3.png',
];

class Inspection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InspectionState();
  }
}

class _InspectionState extends State<Inspection> {
  String reason = '';
  final CarouselController _controller = CarouselController();

  AudioCache player = new AudioCache();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;

    Fluttertoast.showToast(
      msg: 'Pressed $counter times.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3
    );

    const alarmAudioPath = 'sounds/sample1.mp3';
    player.play(alarmAudioPath);

    await prefs.setInt('counter', counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('치매 진단 테스트'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CarouselSlider(
              items: imgList.map((item) => Container(
                child: Center(
                  child: Image.asset(item, fit: BoxFit.fill),
                ),
              )).toList(),
              options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                onPageChanged: onPageChange,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2)
              ),
              carouselController: _controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _controller.previousPage(),
                    child: Text('←'),
                  ),
                ),
                ...Iterable<int>.generate(imgList.length).map(
                  (int pageIndex) => Flexible(
                    child: RaisedButton(
                      onPressed: () => _controller.animateToPage(pageIndex),
                      child: Text("$pageIndex"),
                    ),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _controller.nextPage(),
                    child: Text('→'),
                  ),
                ),
              ],
            ),
            MaterialButton(
              child: Text('Sound test'),
              color: Colors.lightBlue,
              onPressed: () {
                _incrementCounter();
              },
            ),
            SizedBox(
              height: 50,
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