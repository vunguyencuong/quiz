import 'package:auto_route/auto_route.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../route/route.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@RoutePage()
class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: RegisterForm(), // Đặt RegisterForm trực tiếp trong body
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _chatIdController = TextEditingController();

  void _register() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String chatId = _chatIdController.text; // Get chatId from controller

    // Add your registration logic here
    print('Username: $username');
    print('Password: $password');

    // For now, just clear the fields after registration attempt
    _usernameController.clear();
    _passwordController.clear();
    _chatIdController.clear();
    // int code = registerAccount(username, password, username);
    //return response in a varable then push if 200
    registerAccount(username, password, username, chatId).then((value) {
      print(value);
      if (value['status']['code'] == "success") {
        Fluttertoast.showToast(
            msg: "Register success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        AutoRouter.of(context).push(const LoginRoute());
      } else {
        Fluttertoast.showToast(
            msg: "Register failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              controller: _chatIdController,
              decoration: InputDecoration(
                labelText: 'Chat ID',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> registerAccount(
      String username, String password, String fullName, String chatId) async {
    final String apiUrl = '${BASE_URL}/api/v1/auth/register';

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
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'username': username,
        'password': password,
        'fullName': fullName,
        'chatId': chatId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to register account');
    }
  }
}
