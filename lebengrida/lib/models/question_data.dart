class Question {
  final String type;
  final String title;
  final String select_1;
  final String select_2;
  final String select_3;
  final String select_4;
  final String answer;

  Question({this.type, this.title, this.select_1, this.select_2, this.select_3, this.select_4, this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      title: json['title'],
      select_1: json['select_1'],
      select_2: json['select_2'],
      select_3: json['select_3'],
      select_4: json['select_4'],
      answer: json['answer']
    );
  }
}