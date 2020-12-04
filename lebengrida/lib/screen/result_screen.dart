import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lebengrida/data/login_auth.dart';
import 'package:lebengrida/model/result_data.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/service/result_service.dart';
import 'package:lebengrida/service/user_service.dart';
import 'package:provider/provider.dart';

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
  List<String> _testDateList = ['날짜 선택'];
  String _selectedDate = '날짜 선택';
  String _resultStatus = '';
  Color _resultStatusTextColor;

  final _focusNode = FocusScopeNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentBackPressTime;

  // 뒤로가기 버튼 두 번 터치 시 종료
  bool onPressBackButton() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text('뒤로가기 버튼을 한 번더 누르시면 종료됩니다.'))
        );
      return false;
    }
    return true;
  }

  // 각 회원 정보 조회
  Future<User> _getUserInfo(String mobile) async {
    var _user;
    await UserServices.getUserInfo(mobile).then((user) {
      _user = user;
    });
    return _user;
  }

  // 각 회원별 검사 결과 정보 조회
  Future<List<Result>> _getUserResults(String mobile) async {
    var _result;
    await ResultServices.getUserResults(mobile).then((result) {
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

    _getUserResults(widget.mobile).then((value) {
      for (var i = value.length - 1; i > -1; i --) {
        _testDateList.add('${value.length - i}차: ${value[i].testDate.substring(0, 10)}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _getUserInfo(widget.mobile).then((value) {
        _selectedUser = value;
      });

      _getUserResults(widget.mobile).then((value) {
        _userResult = value[Provider.of<LoginAuth>(context, listen: false).currentTestDateIndex];

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

    return FocusScope(
      node: _focusNode,
      child: WillPopScope(
        onWillPop: () async {
          bool result = onPressBackButton();
          return await Future.value(result);
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('검사 결과'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/'))
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/'))
              )
            ],
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
                      '최근 검사일 : ${formatDate(DateTime.parse(_userResult.testDate), [yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '지난 검사 결과 확인',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 20),
                        DropdownButton(
                          value: _selectedDate,
                          items: _testDateList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            String selectedValue = value;
                            setState(() {
                              _selectedDate = value;
                              if(_selectedDate.startsWith('날')) {
                                return;
                              } else {
                                Provider.of<LoginAuth>(context, listen: false).setCurrentTestDateIndex(_testDateList.length - 1 - int.parse(selectedValue.substring(0, 1)));
                              }
                            });
                          },
                        ),
                      ],
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
                                },
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
                    SizedBox(height: 25),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.mode_comment_outlined,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '담당강사 검사결과 평가',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Card(
                      color: Colors.white,
                      child: Text(
                        _userResult.comment,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ];
                } else {
                  _children = <Widget>[
                    SizedBox(height: 220),
                    Center(
                      child: Text(
                        '검사 내역이 없습니다.',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _children,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}