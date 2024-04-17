import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/Options.dart';
import 'package:http/http.dart' as http;
import 'CompleteScreen.dart';

class QuizController extends GetxController {
  var responseData = [].obs;
  var number = 0.obs;
  late Timer _timer;
  var _secondRemaining = 15.obs;
  var shuffledOptions = <String>[].obs;
  var selectedAnswers = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    api();
    startTime();
  }

  Future<void> api() async {
    final response =
    await http.get(Uri.parse('https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];
      responseData.value = data;
      updateShuffleOption();
    }

  }

  void nextQuestion() {
    // _timer.cancel();
    if (number.value == 9) {
      completed();
      number.value = 0;
    } else {
      number.value++;
      _secondRemaining.value = 15;
      updateShuffleOption();
      // startTime();
    }
  }

  void completed() {
    Get.offAll(() => const CompletedScreen());
  }

  void updateShuffleOption() {
    print(responseData[number.value]['correct_answer']);
    print("incorrect");
    // print(responseData[number.value]['incorrect_answer'][0]);
    // print(responseData[number.value]['incorrect_answer'][1]);
    // print(responseData[number.value]['incorrect_answer'][2]);
    print("check data: ");
    print(responseData[number.value]);
    shuffledOptions.value = shuffledOption([
      responseData[number.value]['correct_answer'],
      ...(responseData[number.value]['incorrect_answers'] as List)
    ]);
    for(String i in shuffledOptions){
      print("check: $i");
    }
  }

  List<String> shuffledOption(List<String> option) {
    List<String> shuffledOptions = List.from(option);
    shuffledOptions.shuffle();
    return shuffledOptions;
  }

  void selectAnswer(String answer){
    selectedAnswers.add(answer);
  }

  bool isAnswerSelected(String answer){
    return selectedAnswers.contains(answer);
  }

  void startTime() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (_secondRemaining.value > 0) {
    //     _secondRemaining.value--;
    //   } else {
    //     nextQuestion();
    //     _secondRemaining.value = 15;
    //     updateShuffleOption();
    //   }
    // });
    Future.delayed(const Duration(seconds: 1), () {
      if (_secondRemaining.value > 0) {
        _secondRemaining.value--;
      } else {
        nextQuestion();
        _secondRemaining.value = 15;
        updateShuffleOption();
      }
      if (_secondRemaining.value > 0) {
        startTime(); // Gọi lại hàm này để tiếp tục đếm ngược
      }
    });
  }
}

@RoutePage()
class QuizScreen extends StatelessWidget {
  final QuizController _quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
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
                                "Question ${_quizController.number.value + 1}/10",
                                style: const TextStyle(
                                    color: Color(0xff90CAF9)),
                              )),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Obx(() => Text(_quizController.responseData.isNotEmpty
                                ? _quizController.responseData[_quizController.number.value]['question']
                                : '')),
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
                Obx(() => (_quizController.responseData.isNotEmpty &&
                    _quizController.responseData[_quizController.number.value]
                    ['incorrect_answers'] !=
                        null)
                    ? Column(
                  children: _quizController.shuffledOptions.map((option) {
                    return Options(options: option.toString());
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
