class User {
  final String name;
  final String birth;
  final String age;
  final String gender;
  final String address;
  final String mobile;
  final String protector;

  User({this.name, this.birth, this.age, this.gender, this.address, this.mobile, this.protector});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      birth: json['birth'],
      age: json['age'],
      gender: json['gender'],
      address: json['address'],
      mobile: json['mobile'],
      protector: json['protector']
    );
  }
}