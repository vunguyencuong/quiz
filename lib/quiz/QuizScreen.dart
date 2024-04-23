import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_printer/main.dart';
import 'package:smart_printer/quiz/QuestionOption.dart';
import 'package:smart_printer/route/route.dart';
import 'package:uuid/uuid.dart';
import '../data/Answer.dart';
import '../data/response/ApiResponse.dart';



class QuizController extends GetxController {
  late BuildContext _context;
  var questions = List<Question>.empty(growable: true).obs;
  var config = Config(id: 0, startTime: '', duration: 0).obs;
  var number = 0.obs;
  late Timer _timer;
  var _secondRemaining = 15.obs;
  var shuffledOptions = <Choice>[].obs;
  var selectedAnswers = <Choice>[].obs;
  var numberOfCorrectAnswers = 0.obs;
  var numberOfWrongAnswers = 0.obs;
  var _quizId = -1;
  var selectedChoicesByQuestion = <Question, List<Choice>>{}
      .obs; // Map để lưu các đáp án đã chọn cho mỗi câu hỏi
  // var configData = <Config>[].obs;

  @override
  void onInit() {
    super.onInit();
    startTime();
  }

  void startTime() {
    _secondRemaining.value = config.value.duration * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondRemaining.value == 0) {
        nextQuestion();
      } else {
        _secondRemaining.value--;
      }
    });
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void setQuizId(int id) {
    _quizId = id;
  }

  Future<void> api(String id, String requestId) async {
    final response = await dio.get(
      'http://35.240.189.148:8000/api/v1/join-quiz/$id/$requestId',
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer ${prefs.getString('accessToken')}',
        },
      ),
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(response.data);
      questions.value = apiResponse.data.questions;
      config.value = apiResponse.data.config;
      updateShuffleOption();
    } else {
      AutoRouter.of(_context).push(const CompletedRoute());
    }
  }

  Future<void> submitQuiz(
      {required int quizId, required List<Answer> answers}) async {
    final response = await dio.post(
      'http://35.240.189.148:8000/api/v1/join-quiz/submit/$quizId',
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer ${prefs.getString('accessToken')}',
        },
      ),
      data: {
        "choices": answers.map((answer) => answer.toJson()).toList(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit quiz');
    } else {
      Fluttertoast.showToast(
          msg: "Submit quiz successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void nextQuestion() {
    _timer.cancel();
    if (number.value == questions.length - 1) {
      completed();
      number.value = 0;
    } else {
      number.value++;
      updateShuffleOption();
    }
  }

  void completed() {
    print(selectedChoicesByQuestion);
    submitQuiz(
        quizId: _quizId,
        answers: selectedAnswers
            .map((element) => element.toAnswer(questions[number.value].id))
            .toList());
    AutoRouter.of(_context).push(const CompletedRoute());
  }

  void updateShuffleOption() {
    shuffledOptions.value = List<Choice>.from(questions[number.value].choices);
    shuffledOptions.shuffle();
  }

  void selectAnswer(Choice answer) {
    selectedAnswers.add(answer);
    var currentQuestion = questions[number.value];
    if (!selectedChoicesByQuestion.containsKey(currentQuestion)) {
      selectedChoicesByQuestion[currentQuestion] = [];
    }
    selectedChoicesByQuestion[currentQuestion]!.add(answer);
  }

  void unSelectAnswer(Choice answer) {
    selectedAnswers.remove(answer);
    var currentQuestion = questions[number.value];
    if (selectedChoicesByQuestion.containsKey(currentQuestion)) {
      selectedChoicesByQuestion[currentQuestion]!.remove(answer);
    }
  }

  bool isAnswerSelected(Choice answer) {
    return selectedAnswers.contains(answer);
  }
}

@RoutePage(name: 'quizRoute')
class QuizScreen extends StatelessWidget {
  final QuizController _quizController = Get.put(QuizController());
  final String id;

  QuizScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    _quizController.setContext(context);
    _quizController.setQuizId(int.parse(id));
    final requestId = Uuid().v4();
    return FutureBuilder(
        future: _quizController.api(id,requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 421,
                        width: 480,
                        child: Stack(
                          children: [
                            Container(
                              height: 240,
                              width: 480,
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 22,
                              child: Container(
                                height: 170,
                                width: 340,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        color: const Color(0xff90CAF9)
                                            .withOpacity(.4)),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Obx(() => Text(
                                              "Question ${_quizController.number.value + 1}/ ${_quizController.questions.length}",
                                              style: const TextStyle(
                                                  color: Color(0xff90CAF9)),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Obx(() => Text(
                                            _quizController
                                                .questions[_quizController
                                                    .number.value]
                                                .questionText,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 210,
                              left: 140,
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: Obx(() => Text(
                                        DateFormat('mm:ss').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                _quizController._secondRemaining
                                                        .value *
                                                    1000)),
                                        style: const TextStyle(
                                            color: Color(0xff90CAF9),
                                            fontSize: 25),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Obx(() => (_quizController.shuffledOptions.isNotEmpty)
                              ? Column(
                                  children: _quizController.shuffledOptions
                                      .map((option) {
                                    return QuestionOption(options: option);
                                  }).toList(),
                                )
                              : Container()),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff90CAF9),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5),
                          onPressed: () {
                            _quizController.nextQuestion();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
