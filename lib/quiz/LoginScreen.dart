import 'package:auto_route/auto_route.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_printer/main.dart';

import '../route/route.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isAdmin = false.obs; // Mặc định là false, nghĩa là không phải admin
}

@RoutePage()
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);
  final AuthController _authController = Get.put(AuthController());

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      await login(username, password);
      if (prefs.getString('role') == 'TEACHER') {
        widget._authController.isAdmin.value = true;
      } else if (prefs.getString('role') == 'STUDENT'){
        widget._authController.isAdmin.value = false;
      }
      else{
        return;
      }
      Fluttertoast.showToast(
        msg: "Login success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      _clearFields();
      AutoRouter.of(context).push(const HomeQuizRoute());
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    login("", "");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              ElevatedButton(
                  onPressed: _register, child: const Text('Register')),
            ],
          )
        ],
      ),
    );
  }

  void _register() {
    AutoRouter.of(context).push(const RegisterRoute());
  }

  void _clearFields() {
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String username, String password) async {
    final String apiUrl = '${BASE_URL}/api/v1/auth/login';

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
      },
    );

    if (response.statusCode == 200) {
      prefs.remove('username');
      prefs.remove('role');
      prefs.remove('accessToken');
      prefs.setString('username', response.data['data']['username']);
      prefs.setString('role', response.data['data']['role']);
      prefs.setString('accessToken', response.data['data']['accessToken']);
    } else {
      throw Exception('Failed to login');
    }
  }
}
