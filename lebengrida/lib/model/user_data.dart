class User {
  final String name;
  final String birth;
  final String age;
  final String gender;
  final String address;
  final String mobile;
  final String protectorName;
  final String protectorMobile;
  final String instructor;
  final String joinDate;
  final String updateDate;

  User({this.name, this.birth, this.age, this.gender, this.address, this.mobile, this.protectorName, this.protectorMobile, this.instructor, this.joinDate, this.updateDate});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      birth: json['birth'],
      age: json['age'],
      gender: json['gender'],
      address: json['address'],
      mobile: json['mobile'],
      protectorName: json['protector_name'],
      protectorMobile: json['protector_mobile'],
      instructor: json['instructor'],
      joinDate: json['join_date'],
      updateDate: json['update_date'],
    );
  }
}