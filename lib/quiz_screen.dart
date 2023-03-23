import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Quiz_model.dart';
import 'package:quiz_app/util.dart';
import 'package:quiz_app/viewmodels/quiz_viewmodel.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  var model = QuizProvider();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 9), vsync: this);
    final curvedAnimation =
    CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween<double>(begin: 0, end: 320).animate(curvedAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          model.onTimeOut();
          controller.reset();
          controller.forward();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            model = provider;
            if (provider.a.isNotEmpty) {
              if (!provider.quizFinished) {
                {
                  final question = provider.a[provider.index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(1),
                            width: 320,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 4),
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              alignment: Alignment.center,
                              width: animation.value,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                  '${controller.lastElapsedDuration == null
                                      ? 10
                                      : controller.lastElapsedDuration!
                                      .inSeconds + 1}'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        RichText(
                            text: TextSpan(
                                style: theme.textTheme.bodySmall!.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blueGrey),
                                text: 'Question ${provider.index + 1}',
                                children: [
                                  TextSpan(
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blueGrey.shade300),
                                      text: ' / ${provider.a.length}')
                                ])),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(question.question!,
                            style: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.blueGrey)),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: provider.hasAnswered
                                      ? null
                                      : () {
                                    provider.hasAnswered = true;
                                    provider.selectedOption = index;
                                    provider.checkAnswer(
                                        question.answer ==
                                            question.options![index]);
                                    controller.stop(canceled: false);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 320,
                                    margin:
                                    const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                    padding:
                                    const EdgeInsets.fromLTRB(32, 8, 24, 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: getColorState(
                                                provider.colorState,
                                                index ==
                                                    provider.selectedOption),
                                            width: 2),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    child: Text(
                                      question.options![index],
                                      style: theme.textTheme.headlineSmall!
                                          .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: getColorState(
                                            provider.colorState,
                                            index == provider.selectedOption),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        if (provider.hasAnswered)
                          Text(
                              provider.colorState == 1
                                  ? 'Right Answer'
                                  : 'Wrong Answer',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: provider.colorState == 1
                                      ? Colors.lightGreen
                                      : Colors.redAccent)),
                        const SizedBox(
                          height: 8,
                        ),
                        if (provider
                            .hasAnswered) // show explanation if answered
                          Text(
                            question.explanation!,
                            style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey),
                          ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: LinearProgressIndicator(
                              value: provider.index / provider.a.length,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: FilledButton(
                            onPressed: () {
                              provider.nextQuestion();
                              controller.reset();
                              controller.forward();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 320,
                              child: Text(
                                'Next',
                                style: theme.textTheme.headlineSmall!.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/score.png'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 32, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Right Answers',
                            style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '${provider.rightAnswers}',
                          style: theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 24, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Wrong Answers',
                            style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '${provider.wrongAnswers}',
                          style: theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 24, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            'Not Attempted',
                            style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '${10 - provider.rightAnswers -
                              provider.wrongAnswers}',
                          style: theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        ),
                        const Spacer(),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: FilledButton(
                            onPressed: () {
                              final a = {
                                'right': provider.rightAnswers,
                                'wrong': provider.wrongAnswers,
                                'not_attempted': 10 - provider.rightAnswers -
                                    provider.wrongAnswers,
                                'time': Timestamp.fromDate(DateTime.now())
                              };
                              Utils.a.add(QuizModel.fromJson(a));
                              provider.saveToCloud(a).then((value) => Navigator.pop(context));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 320,
                              child: Text(
                                'Save to cloud',
                                style: theme.textTheme.headlineSmall!.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ]),
                );
              }
            } else {
              return const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Color getColorState(int state, bool selected) {
    if (selected) {
      if (state == 1) {
        return Colors.lightGreen;
      } else {
        return Colors.red;
      }
    }
    return Colors.blueGrey.shade300;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
