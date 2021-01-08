class Result {
  final String mobile;
  final String a1Score;
  final String a2Score;
  final String bScore;
  final String cScore;
  final String dScore;
  final String totalScore;
  String resultStatus;
  final String comment;
  final String testKey;
  final String testDate;

  Result({this.mobile, this.a1Score, this.a2Score, this.bScore, this.cScore, this.dScore, this.totalScore, this.resultStatus, this.comment, this.testKey, this.testDate});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      mobile: json['mobile'],
      a1Score: json['a1_score'],
      a2Score: json['a2_score'],
      bScore: json['b_score'],
      cScore: json['c_score'],
      dScore: json['d_score'],
      totalScore: json['total_score'],
      resultStatus: json['result_status'],
      comment: json['comment'],
      testKey: json['test_key'],
      testDate: json['test_date'],
    );
  }
}