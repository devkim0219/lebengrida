class User {
  String name;
  String birth;
  String gender;
  String address;
  String mobile;
  String protector;

  User({this.name, this.birth, this.gender, this.address, this.mobile, this.protector});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      birth: json['birth'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      mobile: json['mobile'] as String,
      protector: json['protector'] as String
    );
  }
}