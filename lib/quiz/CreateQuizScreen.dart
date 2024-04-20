import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  var genQrCode = 0;

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
                    importJsonFile();
                  }, 
                  child: const Text('Import json name')
              ),
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
                    importJsonFile();
                  },
                  child: const Text('Import json config')
              ),
              TextField(
                  controller: usersController,
                  decoration: InputDecoration(labelText: 'Users')),
              TextButton(
                  onPressed: () async {
                    importJsonFile();
                  },
                  child: const Text('Import json users')
              ),
              TextButton(
                  onPressed: () async {
                    importJsonFile();
                  },
                  child: const Text('Import json questions')
              ),
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
                  if(quizId.isNotEmpty){
                    setState(() {
                      genQrCode = 1;
                    });
                  }
                  print("check");
                  print(genQrCode);
                },
                child: const Text('Submit'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                      if(genQrCode == 1){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                  title: Text('QR Code'),
                                  content: Container(
                                    width: 200, // Điều chỉnh kích thước của Container tùy thuộc vào nhu cầu của bạn
                                    height: 200,
                                    child: Center(
                                      child: QrImageView(
                                         data: genQrCode.toString(),
                                        size: 200,
                                      ),
                                   ),
                                  ),
                              );
                            }
                        );
                      } else{
                        Fluttertoast.showToast(
                          msg: "Failed to gen qr code",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                  },
                  child: const Text("Gen QR Code")
              )
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
      'http://35.197.148.25:8080/api/v1/create-quiz/$sessionId';

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

  //print the json
  print(jsonEncode(<String, dynamic>{
    'name': name,
    'description': description,
    'config': {
      'startTime': startTime,
      'duration': duration,
    },
    'users': users,
    'questions': questions,
  }));
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    Fluttertoast.showToast(
      msg: "Quiz created successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.pop(context); // Dismiss the dialog
    return responseBody['quizId'].toString(); // Extract the 'quizId' field
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
  while (true) {
    final response = await http.get(
      Uri.parse(
          'http://35.197.148.25:8080/api/v1/create-quiz/status/$sessionId'),
      headers: <String, String>{
        'accept': '*/*',
        'username': "string",
      },
    );
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
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

Future<void> importJsonFile() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions:  ['json'],
    );
    if (result != null && result.files.isNotEmpty) {
      List<File> pickedFiles = result.files.map((file) => File(file.path!)).toList();
      print("Imported files: $pickedFiles");
    } else {
      Fluttertoast.showToast(
        msg: "Please select a JSON file",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
}
