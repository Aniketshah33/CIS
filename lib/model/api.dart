class ModelApi {
  String? question;
  int? solution;

  ModelApi({this.question, this.solution});

  factory ModelApi.fromJson(Map<String, dynamic> json) => ModelApi(
        question: json['question'] as String?,
        solution: json['solution'] as int?,
      );
}
