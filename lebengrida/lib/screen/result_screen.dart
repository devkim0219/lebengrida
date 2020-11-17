import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/model/result_data.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/service/result_service.dart';
import 'package:lebengrida/service/user_service.dart';

class ResultPage extends StatefulWidget {
  final String mobile;

  ResultPage({
    Key key,
    @required this.mobile,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  User _selectedUser;
  Result _userResult;
  String _resultStatus = '';
  Color _resultStatusTextColor;

  // 각 회원 정보 조회
  Future<User> _getUserInfo(String mobile) async {
    var _user;
    await UserServices.getUserInfo(mobile).then((user) {
      _user = user;
    });
    return _user;
  }

  // 각 회원별 검사 결과 정보 조회
  Future<Result> _getUserResult(String mobile) async {
    var _result;
    await ResultServices.getUserResult(mobile).then((result) {
      _result = result;
    });
    return _result;
  }

  // 막대 그래프
  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [Color(0xff53fdd7)],
          width: 4,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const double _width = 4.5;
    const double _space = 3.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: _width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        SizedBox(width: _space),
        Container(
          width: _width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(width: _space),
        Container(
          width: _width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        SizedBox(width: _space),
        Container(
          width: _width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(width: _space),
        Container(
          width: _width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _getUserInfo(widget.mobile).then((value) {
        _selectedUser = value;
      });

      _getUserResult(widget.mobile).then((value) {
        _userResult = value;

        // 인지 능력 저하 미도달/도달 에 따른 텍스트 색상 변경
        if (_userResult.resultStatus == 'pass') {
          _resultStatus = '도달';
          _resultStatusTextColor = Colors.black87;

        } else {
          _resultStatus = '미도달';
          _resultStatusTextColor = Colors.red[700];
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: _getUserInfo(widget.mobile),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            List<Widget> _children = [Container()];
            if (snapshot.hasData && _userResult != null) {
              _children = <Widget>[
                Text(
                  '이름 : ${_selectedUser.name}',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '연락처 : ${_userResult.mobile}',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '나이 : ${_selectedUser.age}세',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '총점 : ${_userResult.pointTotal}점',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black87
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '인지 능력 : '
                      ),
                      TextSpan(
                        text: '$_resultStatus',
                        style: TextStyle(
                          color: _resultStatusTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '최근 검사일 : ${_userResult.testDate}',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    color: Color(0xff2c4260),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 10,
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex) {
                              return BarTooltipItem(
                                rod.y.round().toString(),
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            margin: 20,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return 'A-요구';
                                case 1:
                                  return 'B-질문';
                                case 2:
                                  return 'C-단언';
                                case 3:
                                  return 'D-의례화';
                                default:
                                  return '';
                              }
                            }
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14
                            ),
                            margin: 32,
                            reservedSize: 14,
                            getTitles: (value) {
                              if (value == 0) {
                                return '0';
                              } else if (value == 4) {
                                return '4';
                              } else if (value == 8) {
                                return '8';
                              } else {
                                return '';
                              }
                            },
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                y: (int.parse(_userResult.point_1) + int.parse(_userResult.point_2) + int.parse(_userResult.point_3) + int.parse(_userResult.point_4) + .0),
                                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                              ),
                            ],
                            showingTooltipIndicators: [0]
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                y: (int.parse(_userResult.point_5) + int.parse(_userResult.point_6) + int.parse(_userResult.point_7) + int.parse(_userResult.point_8) + .0),
                                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                              ),
                            ],
                            showingTooltipIndicators: [0]
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                y: (int.parse(_userResult.point_9) + int.parse(_userResult.point_10) + int.parse(_userResult.point_11) + int.parse(_userResult.point_12) + .0),
                                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                              ),
                            ],
                            showingTooltipIndicators: [0]
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                y: (int.parse(_userResult.point_13) + int.parse(_userResult.point_14) + int.parse(_userResult.point_15) + int.parse(_userResult.point_16) + .0),
                                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                              ),
                            ],
                            showingTooltipIndicators: [0]
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _children,
            );
          },
        ),
      )
    );
  }
}