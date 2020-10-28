class Result {
  String mobile;
  String point_1;
  String point_2;
  String point_3;
  String point_4;
  String point_5;
  String point_6;
  String point_7;
  String point_8;
  String point_9;
  String point_10;
  String point_11;
  String point_12;
  String point_13;
  String point_14;
  String point_15;
  String point_16;
  String pointTotal;
  String resultStatus;
  String testDate;

  Result({this.mobile, this.point_1, this.point_2, this.point_3, this.point_4, this.point_5, this.point_6, this.point_7, 
            this.point_8, this.point_9, this.point_10, this.point_11, this.point_12, this.point_13, this.point_14, this.point_15, 
            this.point_16, this.pointTotal, this.resultStatus, this.testDate});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      mobile: json['mobile'],
      point_1: json['point_1'],
      point_2: json['point_2'],
      point_3: json['point_3'],
      point_4: json['point_4'],
      point_5: json['point_5'],
      point_6: json['point_6'],
      point_7: json['point_7'],
      point_8: json['point_8'],
      point_9: json['point_9'],
      point_10: json['point_10'],
      point_11: json['point_11'],
      point_12: json['point_12'],
      point_13: json['point_13'],
      point_14: json['point_14'],
      point_15: json['point_15'],
      point_16: json['point_16'],
      pointTotal: json['point_total'],
      resultStatus: json['result_status'],
      testDate: json['test_date'],
    );
  }
}