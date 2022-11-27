import 'dart:developer';

import 'package:flutter/material.dart';

class ScoreController extends ChangeNotifier {
  int questions = 1;
  int score = 0;

  questionNum() {
    questions++;
    notifyListeners();
  }

  getQuestionNum() {
    questions = 1;
    notifyListeners();
  }

  totalScore() {
    score++;

    log(score.toString(), name: "score value in vm");
    notifyListeners();
  }

  resetScore() {
    score = 0;
    notifyListeners();
  }
}
