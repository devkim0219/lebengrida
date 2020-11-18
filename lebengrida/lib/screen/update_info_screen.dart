import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:lebengrida/model/user_data.dart';
import 'package:lebengrida/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:lebengrida/data/login_auth.dart';

class UpdateInfoPage extends StatefulWidget {
  final String mobile;

  UpdateInfoPage({
    Key key,
    @required this.mobile
  }) : super(key: key);

  @override
  UpdateInfoPageState createState() => UpdateInfoPageState();
}

class UpdateInfoPageState extends State<UpdateInfoPage> {
  final _focusNode = FocusScopeNode();
  final _fKey = GlobalKey<FormState>();

  String year;

  String _selectedGender = '남성';
  List<String> _gender = ['남성', '여성'];

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _mobileController;
  TextEditingController _protectorNameController;
  TextEditingController _protectorMobileController;
  User _selectedUser;

  // 시군구 리스트
  final List<String> _sidoGubun = ["시/도 선택","서울특별시","인천광역시","대전광역시","광주광역시","대구광역시","울산광역시","부산광역시","경기도","강원도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주도"];
  final List<String> _seoul = ["구/군 선택","강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"];
  final List<String> _incheon = ["구/군 선택","계양구","남구","남동구","동구","부평구","서구","연수구","중구","강화군","옹진군"];
  final List<String> _daejoen = ["구/군 선택","대덕구","동구","서구","유성구","중구"];
  final List<String> _gwangju = ["구/군 선택","광산구","남구","동구","북구","서구"];
  final List<String> _daegu = ["구/군 선택","남구","달서구","동구","북구","서구","수성구","중구","달성군"];
  final List<String> _ulsan = ["구/군 선택","남구","동구","북구","중구","울주군"];
  final List<String> _busan = ["구/군 선택","강서구","금정구","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구","기장군"];
  final List<String> _gyeonggi = ["구/군 선택","고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시","가평군","양평군","여주군","연천군"];
  final List<String> _gangwon = ["구/군 선택","강릉시","동해시","삼척시","속초시","원주시","춘천시","태백시","고성군","양구군","양양군","영월군","인제군","정선군","철원군","평창군","홍천군","화천군","횡성군"];
  final List<String> _chungbuk = ["구/군 선택","제천시","청주시","충주시","괴산군","단양군","보은군","영동군","옥천군","음성군","증평군","진천군","청원군"];
  final List<String> _chungnam = ["구/군 선택","계룡시","공주시","논산시","보령시","서산시","아산시","천안시","금산군","당진군","부여군","서천군","연기군","예산군","청양군","태안군","홍성군"];
  final List<String> _jeonbuk = ["구/군 선택","군산시","김제시","남원시","익산시","전주시","정읍시","고창군","무주군","부안군","순창군","완주군","임실군","장수군","진안군"];
  final List<String> _jeonnam = ["구/군 선택","광양시","나주시","목포시","순천시","여수시","강진군","고흥군","곡성군","구례군","담양군","무안군","보성군","신안군","영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"];
  final List<String> _gyeongbuk =["구/군 선택","경산시","경주시","구미시","김천시","문경시","상주시","안동시","영주시","영천시","포항시","고령군","군위군","봉화군","성주군","영덕군","영양군","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군"];
  final List<String> _gyeongnam = ["구/군 선택","거제시","김해시","마산시","밀양시","사천시","양산시","진주시","진해시","창원시","통영시","거창군","고성군","남해군","산청군","의령군","창녕군","하동군","함안군","함양군","합천군"];
  final List<String> _jeju = ["구/군 선택","서귀포시","제주시","남제주군","북제주군"];

  String _selectedSido = '시/도 선택';
  String _selectedGuGun = '구/군 선택';
  List<String> _selectedGuGunList = [];
  String _address;
  List<String> _addressArr = [];

  // 회원 정보 수정
  _updateUser(User user) {
    if (_selectedSido == '시/도 선택' || _selectedGuGun == '구/군 선택') {
      Fluttertoast.showToast(
        msg: '주소를 선택해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3
      );
      return;
    } else {
      _address = _selectedSido + " " + _selectedGuGun;
    }

    UserServices.updateUser(_nameController.text, _birthController.text, _selectedGender, _address, _mobileController.text, _protectorNameController.text, _protectorMobileController.text)
        .then((result) {
      if ('success' == result) {
        Fluttertoast.showToast(
          msg: '회원 정보가 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3
        );
      }
    });
    setState(() {
      Provider.of<LoginAuth>(context, listen: false).setCurrentIndex(0);
    });
  }

  // 회원 정보 수정을 위한 해당 회원의 정보 조회
  _getUserInfo(String mobile) {
    UserServices.getUserInfo(mobile).then((user) {
      setState(() {
        _selectedUser = user;
      });
      print('### selected user info -> ${user.mobile}');
      _showValues(_selectedUser);
    });
  }

  // 회원 정보 삭제(탈퇴)
  // _deleteUser(User user) {
  //   UserServices.deleteUser(user.mobile).then((result) {
  //     if ('success' == result) {
  //       Navigator.pushNamed(context, '/');
  //       Fluttertoast.showToast(
  //         msg: '회원 탈퇴가 완료되었습니다.',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3
  //       );
  //     }
  //   });
  // }

  // 입력값 초기화
  _clearValues() {
    _nameController.text = '';
    _birthController.text = '';
    _mobileController.text = '';
    _protectorNameController.text = '';
    _protectorMobileController.text = '';
  }

  // 각 회원의 정보 조회
  _showValues(User user) {
    _nameController.text = user.name;
    _birthController.text = user.birth;

    if (user.gender == 'm') {
      _selectedGender = '남성';
    } else {
      _selectedGender = '여성';
    }

    _addressArr = user.address.split(' ');
    _selectedSido = _addressArr[0];
    _selectedGuGun = _addressArr[1];
    _mobileController.text = user.mobile;
    _protectorNameController.text = user.protectorName;
    _protectorMobileController.text = user.protectorMobile;
  }

  // 출생년도 선택
  _yearPicker() {
    final year = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '출생년도를 선택하세요.',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 4.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200],
            child: YearPicker(
              selectedDate: DateTime(int.parse(_birthController.text)),
              firstDate: DateTime(year - 100),
              lastDate: DateTime(year),
              onChanged: (value) {
                _birthController.text = value.toString().substring(0, 4);
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  // 시도 선택 시 구군 선택 Dropdown 생성
  Widget _makeGuGunSelector(String sido) {
    if (sido == '서울특별시') { _selectedGuGunList = _seoul; }
    else if (sido == '인천광역시') { _selectedGuGunList = _incheon; }
    else if (sido == '대전광역시') { _selectedGuGunList = _daejoen; }
    else if (sido == '광주광역시') { _selectedGuGunList = _gwangju; }
    else if (sido == '대구광역시') { _selectedGuGunList = _daegu; }
    else if (sido == '울산광역시') { _selectedGuGunList = _ulsan; }
    else if (sido == '부산광역시') { _selectedGuGunList = _busan; }
    else if (sido == '경기도') { _selectedGuGunList = _gyeonggi; }
    else if (sido == '강원도') { _selectedGuGunList = _gangwon; }
    else if (sido == '충청북도') { _selectedGuGunList = _chungbuk; }
    else if (sido == '충청남도') { _selectedGuGunList = _chungnam; }
    else if (sido == '전라북도') { _selectedGuGunList = _jeonbuk; }
    else if (sido == '전라남도') { _selectedGuGunList = _jeonnam; }
    else if (sido == '경상북도') { _selectedGuGunList = _gyeongbuk; }
    else if (sido == '경상남도') { _selectedGuGunList = _gyeongnam; }
    else if (sido == '제주도') { _selectedGuGunList = _jeju; }
    else { _selectedGuGunList = ['구/군 선택']; }
    return DropdownButton(
      value: _selectedGuGun,
      items: _selectedGuGunList.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGuGun = value;
          print('selected $sido $_selectedGuGun');
        });
      },
    );
  }

  // 회원 정보 수정 입력 폼
  Widget updateForm() {
    return Form(
      key: _fKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름',
                hintText: '예) 홍길동',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _yearPicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _birthController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '출생년도',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      onSaved: (val) {
                        year = _birthController.text;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return '출생년도를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(
                  Icons.people,
                  color: Colors.black45,
                ),
                SizedBox(width: 15),
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 50,),
                RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _selectedGender,
                  onChanged: (value) => setState(() {
                    _selectedGender = value;
                  }),
                  items: _gender,
                  itemBuilder: (item) => RadioButtonBuilder(item)
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(
                  Icons.location_on,
                  color: Colors.black45,
                ),
                SizedBox(width: 15),
                Text(
                  '주소',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 20),
                DropdownButton(
                  value: _selectedSido,
                  items: _sidoGubun.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSido = value;
                      _selectedGuGun = '구/군 선택';
                    });
                  },
                ),
                SizedBox(width: 15),
                _makeGuGunSelector(_selectedSido),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '연락처',
                hintText: '예) 01012345678',
                prefixIcon: Icon(Icons.phone_android),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '연락처를 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: _protectorNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '보호자명',
                hintText: '예) 홍길동',
                prefixIcon: Icon(Icons.person_add),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '보호자 이름을 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: _protectorMobileController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '보호자 연락처',
                hintText: '예) 01012345678',
                prefixIcon: Icon(Icons.phone_android),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '보호자 연락처를 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          ButtonBar(
            children: <Widget>[
              // FlatButton(
              //   child: Text('초기화'),
              //   onPressed: () {
              //     _clearValues();
              //   },
              // ),
              RaisedButton(
                color: Colors.teal,
                child: Text(
                  '수정',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: () {
                  if (_fKey.currentState.validate()) {
                    _updateUser(_selectedUser);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _mobileController = TextEditingController();
    _protectorNameController = TextEditingController();
    _protectorMobileController = TextEditingController();

    _getUserInfo(widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: FocusScope(
        node: _focusNode,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('회원 정보 수정'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: updateForm(),
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _addUser();
        //   },
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }
}