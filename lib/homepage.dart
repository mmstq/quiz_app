import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Quiz_model.dart';
import 'package:quiz_app/quiz_screen.dart';
import 'package:quiz_app/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fs = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email!)
      .get();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [IconButton(onPressed: (){
          setState(() {
          });
        }, icon: Icon(Icons.refresh))],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: fs,
            builder: (context, snapshot) {

              if (snapshot.hasData) {
                Utils.a = snapshot.data!.docs
                    .map((doc) => QuizModel.fromJson(doc))
                    .toList();
                Utils.a.sort((a,b)=>b.time!.compareTo(a.time!));

                /*snapshot.data!.docs.map((e){
                  QuizModel.fromJson(e);
                });
                print(a);*/
                return SizedBox(
                  height: size.height*0.9,
                  child: ListView(
                    children: Utils.a
                        .map((e) => Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightGreen, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'Answered',
                                          style: theme.textTheme.headlineSmall!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        '${e.right}',
                                        style: theme.textTheme.headlineSmall!
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          'Answered',
                                          style: theme.textTheme.headlineSmall!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        '${e.wrong}',
                                        style: theme.textTheme.headlineSmall!
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'Not Attempted',
                                          style: theme.textTheme.headlineSmall!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        '${e.notAttempted}',
                                        style: theme.textTheme.headlineSmall!
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black54),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                );
              } else {
                return const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          const Spacer(),

        ],
      ),
      floatingActionButton: FilledButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const QuizScreen()));
      },
          child: const Text('Start Quiz')),
    );
  }

/*void ma() async{
    final fs = await FirebaseFirestore.instance.collection('testdeveloper151@gmail.com').get();
    final a = fs.docs.map((doc) => doc.data() ).toList();
    print(a);
    */ /*fs.docs.map((value){
      debugPrint(value.toString());
    });*/ /*
  }*/
}
