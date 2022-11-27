import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:cis/apicontroller/api_data_controller.dart';
import 'package:cis/model/api.dart';

import '../responce/apiresponce.dart';

class ApiController with ChangeNotifier {
  final _apiController = ApiDataController();
  List<int> viewAnswer = [];
  List<int> randomAnswer = List<int>.generate(10, (index) => index + 1);
  final random = math.Random();

  ApiResponse<ModelApi>? responseList;

  Future<void> getApiService() async {
    questionAnswers(ApiResponse.loading());
    _apiController.getQuestionAnswer().then((value) {
      questionAnswers(ApiResponse.completed(value));
      addSolution();
    }).onError((error, stackTrace) {
      questionAnswers(ApiResponse.error(error.toString()));
    });
  }

  questionAnswers(ApiResponse<ModelApi> response) {
    responseList = response;
    notifyListeners();
  }

  void addSolution() {
    viewAnswer.clear();
    viewAnswer.add(responseList!.data?.solution ?? 0);

    while (viewAnswer.length != 4) {
      var randomValue = random.nextInt(randomAnswer.length);
      if (!viewAnswer.contains(randomValue)) {
        viewAnswer.add(randomValue);
      }
    }
    viewAnswer.shuffle();
  }
}
