class Progress {
  final String mobile;
  final String qNo;
  final String attempt;
  final String selectNo;
  final String score;
  final String testKey;
  final String testDate;

  Progress({this.mobile, this.qNo, this.attempt, this.selectNo, this.score, this.testKey, this.testDate});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      mobile: json['mobile'],
      qNo: json['q_no'],
      attempt: json['attempt'],
      selectNo: json['select_no'],
      score: json['score'],
      testKey: json['test_key'],
      testDate: json['test_date'],
    );
  }
}