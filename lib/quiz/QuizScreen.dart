import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_printer/quiz/Options.dart';
import 'package:smart_printer/route/route.dart';
import '../data/response/ApiResponse.dart';
import 'CompleteScreen.dart';

class QuizController extends GetxController {
  late BuildContext _context;
  var responseData = List<Question>.empty(growable: true).obs;
  var number = 0.obs;
  late Timer _timer;
  var _secondRemaining = 15.obs;
  var shuffledOptions = <Choice>[].obs;
  var selectedAnswers = <Choice>[].obs;

  @override
  void onInit() {
    super.onInit();
    startTime();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> api(String id) async {
    final response = await http.get(
      Uri.parse('http://35.240.159.251:8080/api/v1/join-quiz/$id'),
      headers: <String, String>{
        'accept': '*/*',
        'username': 'string',
      },
    );

    if (response.statusCode == 200) {
      print("fasfsaf ${response.body}");
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      responseData.value = apiResponse.data.questions;
      updateShuffleOption();
    }
    else{
      print("fasfsaf error");
      AutoRouter.of(_context).push(const CompletedRoute());
    }
  }

  void nextQuestion() {
    _timer.cancel();
    if (number.value == responseData.length - 1) {
      completed();
      number.value = 0;
    } else {
      number.value++;
      _secondRemaining.value = 15;
      updateShuffleOption();
      startTime();
    }
  }

  void completed() {
    // Navigate to the completed screen
  }

  void updateShuffleOption() {
    shuffledOptions.value = List<Choice>.from(responseData[number.value].choices);
    shuffledOptions.shuffle();
  }

  void selectAnswer(Choice answer) {
    selectedAnswers.add(answer);
  }

  bool isAnswerSelected(Choice answer) {
    return selectedAnswers.contains(answer);
  }

  void startTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondRemaining.value > 0) {
        _secondRemaining.value--;
      } else {
        _timer.cancel();
        nextQuestion();
      }
    });
  }
}

@RoutePage(name: 'quizRoute')
class QuizScreen extends StatelessWidget {
  final QuizController _quizController = Get.put(QuizController());
  final String id;

  QuizScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    _quizController.api(id);
    _quizController.setContext(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '05',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                Text(
                                  '07',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              ],
                            ),
                            Center(
                              child: Obx(() => Text(
                                "Question ${_quizController.number.value + 1}/ ${_quizController.responseData.length}",
                                style: const TextStyle(
                                    color: Color(0xff90CAF9)),
                              )),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Obx(() => Text(
                              _quizController.responseData[_quizController.number.value].questionText,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            )
                            ),
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
                          _quizController._secondRemaining.value.toString(),
                          style: const TextStyle(
                              color: Color(0xff90CAF9), fontSize: 25),
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
                Obx(() => (
                    _quizController.shuffledOptions.isNotEmpty
                )
                    ? Column(
                  children: _quizController.shuffledOptions.map((option) {
                    return Options(options: option);
                  }).toList(),
                )
                    : Container()),
              ],
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff90CAF9),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5
                ), onPressed: () {
                _quizController.nextQuestion();
              },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('Next', style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
