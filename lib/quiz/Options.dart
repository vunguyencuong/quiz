import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'QuizScreen.dart';


class Options extends StatelessWidget {
  final String options;
  final QuizController controller = Get.find();

  Options({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedAnswers.contains(options);
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              controller.selectAnswer(options);
            },
            child: Container(
              height: 48,
              width: 240,
              margin: const EdgeInsets.symmetric(vertical: 2), // Khoảng cách giữa các câu hỏi
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 3,
                  color: isSelected ? Color(0xff90CAF9) : Color(0xff90CAF9),
                ),
                color: isSelected ? Color(0xFFBBDEFB) : Colors.transparent,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(options, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
