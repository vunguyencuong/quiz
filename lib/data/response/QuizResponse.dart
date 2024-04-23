import 'package:smart_printer/data/Answer.dart';

class QuizResponse {
  final Status status;
  final Data data;

  QuizResponse({required this.status, required this.data});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      status: Status.fromJson(json['status']),
      data: Data.fromJson(json['data']),
    );
  }
}

class Status {
  final String code;
  final String message;

  Status({required this.code, required this.message});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json['code'],
      message: json['message'],
    );
  }
}

class Data {
  final int id;
  final String name;
  final String description;
  final Config config;
  final List<Question> questions;

  Data({required this.id, required this.name, required this.description, required this.config, required this.questions});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      config: Config.fromJson(json['config']),
      questions: (json['questions'] as List).map((i) => Question.fromJson(i)).toList(),
    );
  }
}

class Config {
  final int id;
  final String startTime;
  final int duration;

  Config({required this.id, required this.startTime, required this.duration});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      id: json['id'],
      startTime: json['startTime'],
      duration: json['duration'],
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final List<Choice> choices;
  final int order;
  final bool multipleChoice;

  Question({required this.id, required this.questionText, required this.choices, required this.order, required this.multipleChoice});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      choices: (json['choices'] as List).map((i) => Choice.fromJson(i)).toList(),
      order: json['order'],
      multipleChoice: json['multipleChoice'],
    );
  }
}

class Choice {
  final int id;
  final String choiceText;
  final int order;

  Choice({required this.id, required this.choiceText, required this.order});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      choiceText: json['choiceText'],
      order: json['order'],
    );
  }

  //mapper to answer
  Answer toAnswer(int questionId) {
    return Answer(questionId: questionId, choiceId: id);
  }

}