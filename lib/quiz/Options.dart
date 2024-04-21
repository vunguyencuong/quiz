import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_printer/data/response/ApiResponse.dart';

import 'QuizScreen.dart';


class Options extends StatelessWidget {
  final Choice options;
  final QuizController controller = Get.find();
  late RxBool isSelected;
  Options({Key? key, required this.options}) : super(key: key){
    isSelected = RxBool(controller.selectedAnswers.contains(options));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      isSelected.value = controller.selectedAnswers.contains(options);
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              if (isSelected.value) {
                isSelected.value = !isSelected.value;
                controller.unSelectAnswer(options);
              } else {
                isSelected.value = true;
                controller.selectAnswer(options);
              }
            },
            child: Container(
              height: 48,
              width: 320,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 3,
                  color: isSelected.value ? Color(0xff90CAF9) : Color(0xff90CAF9),
                ),
                color: isSelected.value ? Color(0xFFBBDEFB) : Colors.transparent,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        options.choiceText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2, // Giới hạn số dòng hiển thị
                        overflow: TextOverflow.ellipsis, // Hiển thị dấu "..." khi vượt quá số dòng
                      ),
                    ),
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

