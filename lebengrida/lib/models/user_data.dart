class User {
  final String name;
  final String birth;
  final String age;
  final String gender;
  final String address;
  final String mobile;
  final String protectorName;
  final String protectorMobile;

  User({this.name, this.birth, this.age, this.gender, this.address, this.mobile, this.protectorName, this.protectorMobile});

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
    );
  }
}