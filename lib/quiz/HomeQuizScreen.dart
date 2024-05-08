import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../route/route.dart';
import 'LoginScreen.dart';

@RoutePage()
class HomeQuizScreen extends StatelessWidget {
  final AuthController _authController = Get.find(); // Sử dụng Get.find() để lấy AuthController đã khởi tạo trước đó
  final TextEditingController _quizCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Quiz'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              prefs.setBool('isLoggedIn', false);
              // Navigate back to the LoginScreen
              AutoRouter.of(context).pushAndPopUntil(const LoginRoute(), predicate: (route) => false);
            },
          ),
        ],
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
                 TextField(
                   controller: _quizCodeController,
                  decoration: InputDecoration(
                    labelText: 'Enter Quiz Code',
                    fillColor: Color(0xff90CAF9),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AutoRouter.of(context).push(QuizRoute(id: _quizCodeController.text));
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

