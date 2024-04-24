class ResultResponse {
  final ResultStatus status;
  final ResultData data;

  ResultResponse({required this.status, required this.data});

  factory ResultResponse.fromJson(Map<String, dynamic> json) {
    return ResultResponse(
      status: ResultStatus.fromJson(json['status']),
      data: ResultData.fromJson(json['data']),
    );
  }
}

class ResultStatus {
  final String code;
  final String message;

  ResultStatus({required this.code, required this.message});

  factory ResultStatus.fromJson(Map<String, dynamic> json) {
    return ResultStatus(
      code: json['code'],
      message: json['message'],
    );
  }
}

class ResultData {
  final int id;
  final double score;
  final List<ResultQuestion> questions;

  ResultData({required this.id, required this.score, required this.questions});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      id: json['id'] ?? 0,
      score: json['score'] ?? 0,
      questions: (json['questions'] as List).map((i) => ResultQuestion.fromJson(i)).toList(),
    );
  }
}

class ResultQuestion {
  final int id;
  final String questionText;
  final List<ResultChoice> choices;
  final int order;
  final bool multipleChoice;

  ResultQuestion({required this.id, required this.questionText, required this.choices, required this.order, required this.multipleChoice});

  factory ResultQuestion.fromJson(Map<String, dynamic> json) {
    return ResultQuestion(
      id: json['id'] ?? 0,
      questionText: json['questionText'] ?? '',
      choices: (json['choices'] as List).map((i) => ResultChoice.fromJson(i)).toList(),
      order: json['order'] ?? 0,
      multipleChoice: json['multipleChoice'] ?? false,
    );
  }
}

class ResultChoice {
  final int id;
  final String choiceText;
  final int order;
  final bool correct;
  final bool selected;

  ResultChoice({required this.id, required this.choiceText, required this.order, required this.correct, required this.selected});

  factory ResultChoice.fromJson(Map<String, dynamic> json) {
    return ResultChoice(
      id: json['id'] ?? 0,
      choiceText: json['choiceText'] ?? '',
      order: json['order'] ?? 0,
      correct: json['correct'] ?? false,
      selected: json['selected'] ?? false,
    );
  }
}