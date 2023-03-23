class Question {
  String? question;
  List<String>? options;
  String? answer;
  String? explanation;

  Question({this.question, this.options, this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'].cast<String>();
    answer = json['answer'];
    explanation = json['explanation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['options'] = options;
    data['answer'] = answer;
    data['explanation'] = explanation;
    return data;
  }
}