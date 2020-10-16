class Question {
  String type;
  String title;
  String choice_1;
  String choice_2;
  String choice_3;
  String choice_4;
  String answer;

  Question({this.type, this.title, this.choice_1, this.choice_2, this.choice_3, this.choice_4, this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'] as String,
      title: json['title'] as String,
      choice_1: json['choice_1'] as String,
      choice_2: json['choice_2'] as String,
      choice_3: json['choice_3'] as String,
      choice_4: json['choice_4'] as String,
      answer: json['answer'] as String,
    );
  }
}