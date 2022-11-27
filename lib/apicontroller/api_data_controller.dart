import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/api.dart';

class ApiDataController with ChangeNotifier {
  Future<ModelApi> getQuestionAnswer() async {
    try {
      final response = await http
          .get(Uri.parse("https://marcconrad.com/uob/smile/api.php?out=json"));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        // log(jsonResponse.toString(), name: "jsonResponse");
        return ModelApi.fromJson(jsonResponse);
      } else {
        throw Exception("Api Error");
      }
    } on SocketException {
      throw Exception("Internet connection not available");
    }
  }
}
