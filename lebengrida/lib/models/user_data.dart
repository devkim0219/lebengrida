class User {
  String name;
  String mobile;
  String birth;
  String gender;
  String address;

  User({this.name, this.mobile, this.birth, this.gender, this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      birth: json['birth'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String
    );
  }
}