import 'dart:async';

import 'package:cis/controller/api_controller.dart';
import 'package:cis/controller/score_controller.dart';
import 'package:cis/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../responce/status.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  ScoreController scoreController = ScoreController();

  static const maxSeconds = 90;
  int seconds = maxSeconds;
  Timer? timer;

  ApiController apiController = ApiController();
  List<String> solutionIndex = ['i', 'ii', 'iii', 'iv'];
  int solutionIndicator = -1;

  showQuestion() async {
    await apiController.getApiService();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (seconds == 0) {
        timer.cancel();

        // ignore: use_build_context_synchronously

        scoreController.resetScore();
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  void initState() {
    showQuestion();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (seconds == 0)
            ? Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            iconSize: 30,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()),
                              );
                            },
                            icon: const Icon(Icons.skip_next))
                      ],
                    ),
                    const SizedBox(
                      height: 300,
                    ),
                    Center(
                      child: Text(
                        "Score : ${scoreController.score}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: (seconds == 0) ? null : linearIndicator(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          //color: Color.fromARGB(255, 236, 236, 236)
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 222, 222, 222),
                              child: Text(
                                "Your Score :${scoreController.score} ",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            ChangeNotifierProvider<ApiController>(
                              create: (BuildContext context) => apiController,
                              child: Consumer<ApiController>(
                                  builder: ((context, value, _) {
                                switch (value.responseList?.status) {
                                  case Status.loading:
                                    return const CircularProgressIndicator(); //

                                  case Status.error:
                                    return Text(value.responseList?.message
                                            .toString() ??
                                        '');
                                  case Status.completed:
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 250,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(value
                                                          .responseList
                                                          ?.data!
                                                          .question
                                                          .toString() ??
                                                      ""))),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 3,
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 15,
                                                    mainAxisSpacing: 30),
                                            itemCount: value.viewAnswer.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 223, 223, 223),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ListTile(
                                                  leading: Text(
                                                    solutionIndex[value
                                                        .viewAnswer
                                                        .indexOf(
                                                            value.viewAnswer[
                                                                index])],
                                                    style: const TextStyle(
                                                        // color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15),
                                                  ),
                                                  onTap: () async {
                                                    setState(() {
                                                      solutionIndicator = value
                                                          .viewAnswer
                                                          .indexOf(
                                                              value.viewAnswer[
                                                                  index]);
                                                    });

                                                    if (value.responseList
                                                            ?.data!.solution
                                                            .toString() ==
                                                        value.viewAnswer[index]
                                                            .toString()) {
                                                      scoreController
                                                          .totalScore();

                                                      scoreController
                                                          .questionNum();

                                                      Future.delayed(
                                                        const Duration(
                                                            seconds: 1),
                                                        () async {
                                                          await apiController
                                                              .getApiService();

                                                          setState(() {
                                                            solutionIndicator =
                                                                -1;
                                                          });
                                                        },
                                                      );
                                                    } else {
                                                      Future.delayed(
                                                        const Duration(
                                                            seconds: 1),
                                                        () async {
                                                          await apiController
                                                              .getApiService();

                                                          setState(() {
                                                            solutionIndicator =
                                                                -1;
                                                          });
                                                        },
                                                      );

                                                      scoreController
                                                          .questionNum();
                                                    }
                                                  },
                                                  title: Text(
                                                    value.viewAnswer[index]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    );
                                  default:
                                    Container();
                                }
                                return Container();
                              })),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget linearIndicator() {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LinearProgressIndicator(
            color: Colors.green,
            value: seconds / maxSeconds,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [timerDisplay()],
          )
        ],
      ),
    );
  }

  Widget timerDisplay() {
    return FittedBox(
      child: Text(
        seconds.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }
}
