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
  final CarouselController _carouselController = CarouselController();

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
        title: Text('삽화 읽기'),
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
              carouselController: _carouselController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _carouselController.previousPage(),
                    child: Text('←'),
                  ),
                ),
                ...Iterable<int>.generate(imgList.length).map(
                  (int pageIndex) => Flexible(
                    child: RaisedButton(
                      onPressed: () => _carouselController.animateToPage(pageIndex),
                      child: Text("$pageIndex"),
                    ),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _carouselController.nextPage(),
                    child: Text('→'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              child: Text('Sound test'),
              color: Colors.teal,
              onPressed: () {
                _incrementCounter();
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: Colors.teal,
              child: Text('문제 보기'),
              onPressed: () {
                Navigator.pushNamed(context, '/question');
              },
            ),
          ],
        ),
      )
    );
  }
}