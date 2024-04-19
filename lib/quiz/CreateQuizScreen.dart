import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



@RoutePage()
class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  String qrData = 'This is a sample QR code data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quizz'),
      ),
      body: Container(
        color: Colors.white, // Màu nền của màn hình
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 1
              },
              child: const Text('Import File JSON 1'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 2
              },
              child: const Text('Import File JSON 2'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút import file JSON 3
              },
              child: const Text('Import File JSON 3'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                createQuiz(
                  name: 'string',
                  description: 'string',
                  startTime: '2024-04-19T16:09:54.111Z',
                  duration: '00:00:00',
                  users: ['string'],
                  questions: [
                    {
                      'questionText': 'string',
                      'choices': [
                        {
                          'choiceText': 'string',
                          'correct': true,
                          'order': 0,
                        },
                      ],
                      'order': 0,
                      'quizId': 0,
                      'multipleChoice': true,
                    },
                  ],
                );
                setState(() {
                  qrData = 'Dữ liệu của bạn';
                });
                // Hiển thị dialog chứa hình ảnh mã QR
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('QR Code'),
                      content: QrImageView(
                        data: qrData,
                        version: 1,
                        size: 200.0,
                        gapless: false,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đóng'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createQuiz({
  required String name,
  required String description,
  required String startTime,
  required String duration,
  required List<String> users,
  required List<Map<String, dynamic>> questions,
}) async {
  final String apiUrl = 'http://35.197.148.25:8080/api/v1/create-quiz/1';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'accept': '*/*',
      'username': 'string',
      'role': 'TEACHER',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description,
      'config': {
        'startTime': startTime,
        'duration': duration,
      },
      'users': users,
      'questions': questions,
    }),
  );

  if (response.statusCode == 200) {
    print('Quiz created successfully');
  } else {
    print('Failed to create quiz. Status code: ${response.statusCode}');
  }
}