import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz_app/Quiz_model.dart';
import 'package:quiz_app/question.dart';
import 'package:quiz_app/util.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> a = [];
  int index = 0;
  bool hasAnswered = false;
  int _colorState = 0;
  int selectedOption = -1;
  bool quizFinished = false;

  int get colorState => _colorState;
  set colorState(int value) {
    _colorState = value;
  }

  int rightAnswers = 0;
  int wrongAnswers = 0;



  QuizProvider(){
    getQuestions();
  }

  void getQuestions() async {
    await FirebaseFirestore.instance.collection('quiz').get().then((value){
      for(var i in value.docs){
        a.add(Question.fromJson(i.data()));
      }
    });
    notifyListeners();
  }
  void nextQuestion(){
    hasAnswered = false;
    index += 1;
    colorState = 0;
    checkQuizFinished();
    selectedOption = -1;
  }
  void checkAnswer(bool isCorrect){
    if (isCorrect) {
      colorState = 1;
      rightAnswers += 1;
    }else{
      colorState=2;
      wrongAnswers +=1;
    }
    notifyListeners();
  }
  void onTimeOut(){
    index += 1;
    checkQuizFinished();

  }

  void checkQuizFinished(){
    if(index > 9){
      quizFinished = true;
    }
    notifyListeners();
  }

  Future saveToCloud(Map<String, dynamic> map) async{
    final fs = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!);

    return fs.add(map);
  }
}
