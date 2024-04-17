import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/route.dart';
import 'LoginScreen.dart';

@RoutePage()
class HomeQuizScreen extends StatelessWidget {
  final AuthController _authController = Get.find(); // Sử dụng Get.find() để lấy AuthController đã khởi tạo trước đó

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Obx(
                () => _authController.isAdmin.value
                ? ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).push(const CreateQuizRoute());
              },
              child: const Text('Create Quiz'),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Quiz Code',
                    fillColor: Color(0xff90CAF9),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const QuizRoute());
                  },
                  child: const Text('Join Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

