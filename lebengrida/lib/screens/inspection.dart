import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

// final List<String> imgList = [
//   'assets/images/dog_1.png',
//   'assets/images/dog_2.png',
//   'assets/images/dog_3.png',
// ];

class Inspection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InspectionState();
  }
}

class _InspectionState extends State<Inspection> {
  String reason = '';
  // final CarouselController _carouselController = CarouselController();
  
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('삽화 구연'),
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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // CarouselSlider(
            //   items: imgList.map((item) => Container(
            //     child: Center(
            //       child: Image.asset(item, fit: BoxFit.fill),
            //     ),
            //   )).toList(),
            //   options: CarouselOptions(
            //     enlargeCenterPage: true,
            //     aspectRatio: 16/9,
            //     onPageChanged: onPageChange,
            //     autoPlay: true,
            //     autoPlayInterval: Duration(seconds: 2)
            //   ),
            //   carouselController: _carouselController,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Flexible(
            //       child: RaisedButton(
            //         onPressed: () => _carouselController.previousPage(),
            //         child: Text('←'),
            //       ),
            //     ),
            //     ...Iterable<int>.generate(imgList.length).map(
            //       (int pageIndex) => Flexible(
            //         child: RaisedButton(
            //           onPressed: () => _carouselController.animateToPage(pageIndex),
            //           child: Text("$pageIndex"),
            //         ),
            //       ),
            //     ),
            //     Flexible(
            //       child: RaisedButton(
            //         onPressed: () => _carouselController.nextPage(),
            //         child: Text('→'),
            //       ),
            //     ),
            //   ],
            // ),
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: FlickPortraitControls(),
              ),
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
      ),
    );
  }
}