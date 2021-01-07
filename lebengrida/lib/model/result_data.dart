class Result {
  final String mobile;
  final String select_1;
  final String point_1;
  final String select_2;
  final String point_2;
  final String select_3;
  final String point_3;
  final String select_4;
  final String point_4;
  final String select_5;
  final String point_5;
  final String select_6;
  final String point_6;
  final String select_7;
  final String point_7;
  final String select_8;
  final String point_8;
  final String select_9;
  final String point_9;
  final String select_10;
  final String point_10;
  final String select_11;
  final String point_11;
  final String select_12;
  final String point_12;
  final String select_13;
  final String point_13;
  final String select_14;
  final String point_14;
  final String select_15;
  final String point_15;
  final String select_16;
  final String point_16;
  final String select_17;
  final String point_17;
  final String select_18;
  final String point_18;
  final String select_19;
  final String point_19;
  final String select_20;
  final String point_20;
  final String pointTotal;
  String resultStatus;
  final String comment;
  final String testDate;

  Result({this.mobile,
          this.select_1, this.point_1, this.select_2, this.point_2, this.select_3, this.point_3, this.select_4, this.point_4, this.select_5, this.point_5,
          this.select_6, this.point_6, this.select_7, this.point_7, this.select_8, this.point_8, this.select_9, this.point_9, this.select_10, this.point_10,
          this.select_11, this.point_11, this.select_12, this.point_12, this.select_13, this.point_13, this.select_14, this.point_14, this.select_15, this.point_15,
          this.select_16, this.point_16, this.select_17, this.point_17, this.select_18, this.point_18, this.select_19, this.point_19, this.select_20, this.point_20,
          this.pointTotal, this.resultStatus, this.comment, this.testDate});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      mobile: json['mobile'],
      select_1: json['select_1'],
      point_1: json['point_1'],
      select_2: json['select_2'],
      point_2: json['point_2'],
      select_3: json['select_3'],
      point_3: json['point_3'],
      select_4: json['select_4'],
      point_4: json['point_4'],
      select_5: json['select_5'],
      point_5: json['point_5'],
      select_6: json['select_6'],
      point_6: json['point_6'],
      select_7: json['select_7'],
      point_7: json['point_7'],
      select_8: json['select_8'],
      point_8: json['point_8'],
      select_9: json['select_9'],
      point_9: json['point_9'],
      select_10: json['select_10'],
      point_10: json['point_10'],
      select_11: json['select_11'],
      point_11: json['point_11'],
      select_12: json['select_12'],
      point_12: json['point_12'],
      select_13: json['select_13'],
      point_13: json['point_13'],
      select_14: json['select_14'],
      point_14: json['point_14'],
      select_15: json['select_15'],
      point_15: json['point_15'],
      select_16: json['select_16'],
      point_16: json['point_16'],
      select_17: json['select_17'],
      point_17: json['point_17'],
      select_18: json['select_18'],
      point_18: json['point_18'],
      select_19: json['select_19'],
      point_19: json['point_19'],
      select_20: json['select_20'],
      point_20: json['point_20'],
      pointTotal: json['point_total'],
      resultStatus: json['result_status'],
      comment: json['comment'],
      testDate: json['test_date'],
    );
  }
}