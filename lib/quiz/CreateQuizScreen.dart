import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@RoutePage()
class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController usersController = TextEditingController();
  var genQrCode = "";

  List pickedFiles = [];

  List<Map<String, dynamic>> questions = [
    {
      'questionText': 'What is the capital of France?',
      'choices': [
        {
          'choiceText': 'Paris',
          'correct': true,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'London',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'Berlin',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'Madrid',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
      ],
      'order': 0,
      'quizId': 0,
      'multipleChoice': true, // Set 'multipleChoice' to true
    },
    {
      'questionText': 'What is the capital of England?',
      'choices': [
        {
          'choiceText': 'Paris',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'London',
          'correct': true,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'Berlin',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
        {
          'choiceText': 'Madrid',
          'correct': false,
          'order': 0, // Add the 'order' field
        },
      ],
      'order': 1,
      'quizId': 0,
      'multipleChoice': true, // Set 'multipleChoice' to true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quizz'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['json']);
                    if (result != null) {
                      List<File> pickedFiles =
                          result.files.map((file) => File(file.path!)).toList();
                      print("Imported files: $pickedFiles");
                      File file = File(result.files.single.path!);
                      try {
                        String contents = await file.readAsString();
                        Map<String, dynamic> jsonData = json.decode(contents);
                        String name = jsonData['name'] ?? '';
                        String description = jsonData['description'] ?? '';
                        nameController.text = name;
                        descriptionController.text = description;
                      } catch (e) {
                        print("Error reading file: $e");
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select a JSON file",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text('Import json quiz')),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'),
                readOnly: true, // make it uneditable by user
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Format the date-time string to include an offset from UTC/Greenwich
                    startTimeController.text =
                        "${pickedDate.toUtc().toIso8601String()}";
                  }
                },
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(labelText: 'Duration'),
                readOnly: true, // make it uneditable by user
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final durationInMinutes =
                        pickedTime.hour * 60 + pickedTime.minute;
                    durationController.text = durationInMinutes.toString();
                  }
                },
              ),
              TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['json']);
                    if (result != null) {
                      List<File> pickedFiles =
                          result.files.map((file) => File(file.path!)).toList();
                      print("Imported files: $pickedFiles");
                      File file = File(result.files.single.path!);
                      try {
                        String contents = await file.readAsString();
                        Map<String, dynamic> jsonData = json.decode(contents);
                        String startTime =
                            jsonData['startTime'].toString() ?? '';
                        String duration = jsonData['duration'].toString() ?? '';
                        print(startTime);
                        print(duration);
                        startTimeController.text = startTime;
                        durationController.text = duration;
                      } catch (e) {
                        print("Error reading file: $e");
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select a JSON file",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text('Import json config')),
              TextField(
                  controller: usersController,
                  decoration: InputDecoration(labelText: 'Users')),
              TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['json']);
                    if (result != null) {
                      List<File> pickedFiles =
                          result.files.map((file) => File(file.path!)).toList();
                      print("Imported files: $pickedFiles");
                      File file = File(result.files.single.path!);
                      try {
                        String contents = await file.readAsString();
                        List<dynamic> jsonData = json.decode(contents);
                        String startTime = jsonData[0] ?? '';
                        usersController.text = startTime;
                      } catch (e) {
                        print("Error reading file: $e");
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select a JSON file",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text('Import json users')),
              TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['json']);
                    if (result != null) {
                      List<File> pickedFiles =
                          result.files.map((file) => File(file.path!)).toList();
                      print("Imported files: $pickedFiles");
                      File file = File(result.files.single.path!);
                      try {
                        String contents = await file.readAsString();
                        questions = (json.decode(contents) as List<dynamic>)
                            .cast<Map<String, dynamic>>();
                        print("questions: $questions");
                        showPreviewDialog(context, questions);
                      } catch (e) {
                        print("Error reading file: $e");
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select a JSON file",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text('Import json questions')),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final sessionId = Uuid().v4();
                  final quizId = await createQuiz(
                    sessionId: sessionId,
                    context: context,
                    name: nameController.text,
                    description: descriptionController.text,
                    startTime: startTimeController.text,
                    duration: int.parse(durationController.text),
                    users: [usersController.text],
                    questions: questions,
                  );
                  if (quizId.isNotEmpty) {
                    setState(() {
                      genQrCode = quizId;
                    });
                  }
                },
                child: const Text('Submit'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    if (genQrCode.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('QR Code'),
                              content: Container(
                                width: 200,
                                // Điều chỉnh kích thước của Container tùy thuộc vào nhu cầu của bạn
                                height: 200,
                                child: Center(
                                  child: QrImageView(
                                    data:
                                        "http://35.240.159.251:8080/api/v1/join-quiz/$genQrCode",
                                    size: 200,
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      Fluttertoast.showToast(
                        msg: "Failed to gen qr code",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text("Gen QR Code"))
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> createQuiz({
  required String sessionId,
  required BuildContext context,
  required String name,
  required String description,
  required String startTime,
  required int duration,
  required List<String> users,
  required List<Map<String, dynamic>> questions,
}) async {
  showLoadingDialog(context, sessionId);
  final String apiUrl =
      'http://35.240.189.148:8000/api/v1/create-quiz/$sessionId';

  Dio dio = Dio();
  dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ),
    CurlLoggerDioInterceptor(),
  ]);

  final response = await dio.post(
    apiUrl,
    options: Options(
      headers: <String, String>{
        'accept': '*/*',
        'username': 'viet',
        'Authorization':
            'Bearer eyJraWQiOiI2NmFURWJ1RFlSblBxT2UwNnZDbzZrOGh3R3BhRk9ybiIsImFsZyI6IkhTMjU2In0.eyJleHAiOjE3MTM4MDcyNzQsImlhdCI6MTcxMzgwNjM3NSwidXNlcm5hbWUiOiJ2aWV0Iiwicm9sZSI6IlRFQUNIRVIifQ.quvAEdLsJVgfpmiRAWgVbKWx48kRjBFDR2qCamKJOfo',
        'Content-Type': 'application/json',
      },
    ),
    data: {
      'name': name,
      'description': description,
      'config': {
        'startTime': startTime,
        'duration': duration,
      },
      'users': users,
      'questions': questions,
    },
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
      msg: "Quiz created successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.pop(context); // Dismiss the dialog
    return response.data['data']['id'].toString();
  } else {
    Fluttertoast.showToast(
      msg: "Failed to create quiz ${response.statusCode}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    print('Failed to create quiz. Status code: ${response.statusCode}');
    Navigator.pop(context); // Dismiss the dialog
    throw Exception('Failed to create quiz');
  }
}

Stream<String> getStatus(String sessionId) async* {
  Dio dio = Dio();
  dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ),
    CurlLoggerDioInterceptor(),
  ]);
  while (true) {
    final response = await dio.get(
      'http://35.240.189.148:8000/api/v1/create-quiz/status/$sessionId',
      options: Options(
        headers: <String, String>{
          'accept': '*/*',
          'Authorization':
              'Bearer eyJraWQiOiI2NmFURWJ1RFlSblBxT2UwNnZDbzZrOGh3R3BhRk9ybiIsImFsZyI6IkhTMjU2In0.eyJleHAiOjE3MTM4MDcyNzQsImlhdCI6MTcxMzgwNjM3NSwidXNlcm5hbWUiOiJ2aWV0Iiwicm9sZSI6IlRFQUNIRVIifQ.quvAEdLsJVgfpmiRAWgVbKWx48kRjBFDR2qCamKJOfo',
          'username': "viet",
        },
      ),
    );
    final Map<String, dynamic> responseBody = response.data;
    yield responseBody['data'] as String;
    await Future.delayed(Duration(seconds: 1));
  }
}

void showLoadingDialog(BuildContext context, String sessionId) {
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
                stream: getStatus(sessionId),
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

void showPreviewDialog(
    BuildContext context, List<Map<String, dynamic>> questions) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Preview Questions'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (BuildContext context, int index) {
              final question = questions[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: ${question['questionText']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Choices:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (question['choices'] as List<dynamic>)
                            .map((choice) {
                          return Text(
                            '- ${choice['choiceText']} ${choice['correct'] ? '(Correct)' : ''}',
                            style: TextStyle(
                              color: choice['correct']
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
