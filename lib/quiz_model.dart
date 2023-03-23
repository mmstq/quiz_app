import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  QuizModel({
      required this.right,
      required this.wrong,
      required this.notAttempted,
      required this.time,});

  QuizModel.fromJson(dynamic json) {
    right = json['right'];
    wrong = json['wrong'];
    notAttempted = json['not_attempted'];
    time = json['time'];
  }
  int? right;
  int? wrong;
  int? notAttempted;
  Timestamp? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['right'] = right;
    map['wrong'] = wrong;
    map['not_attempted'] = notAttempted;
    map['time'] = time;
    return map;
  }

}