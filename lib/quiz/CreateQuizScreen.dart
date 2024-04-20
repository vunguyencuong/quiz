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
              onPressed: () async {
                try {
                  final quizId = await createQuiz(
                    context: context,
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
                    qrData =
                        quizId; // Use the returned 'quizId' as the QR code data
                  });
                  QrImage(
                   QrCode.fromData(data: qrData, errorCorrectLevel: QrErrorCorrectLevel.L),
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            TextButton(
                              onPressed: () {
                                // Implement your functionality to open the link
                              },
                              child: Text(
                                  'http://35.197.148.25:8080/api/v1/create-quiz/$quizId'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } catch (e) {
                  print('Failed to create quiz: $e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> createQuiz({
  required BuildContext context,
  required String name,
  required String description,
  required String startTime,
  required String duration,
  required List<String> users,
  required List<Map<String, dynamic>> questions,
}) async {
  showLoadingDialog(context);
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

  Navigator.pop(context); // Dismiss the dialog

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody['quizId'] as String; // Extract the 'quizId' field
  } else {
    print('Failed to create quiz. Status code: ${response.statusCode}');
    throw Exception('Failed to create quiz');
  }
}

Stream<String> getStatus() async* {
  while (true) {
    final response = await http.get(
      Uri.parse('http://35.197.148.25:8080/api/v1/create-quiz/status/1'),
      headers: <String, String>{
        'accept': '*/*',
        'username': 'string',
      },
    );
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    yield responseBody['data'] as String;
    await Future.delayed(Duration(seconds: 1));
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              StreamBuilder<String>(
                stream: getStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Status: ${snapshot.data}');
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
