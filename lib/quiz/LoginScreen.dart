import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../route/route.dart';

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

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    print('Username: $username');
    print('Password: $password');

    if (username.contains("admin")) {
      widget._authController.isAdmin.value = true; // Đặt isAdmin thành true nếu là admin
    } else {
      widget._authController.isAdmin.value = false; // Đặt isAdmin thành false nếu không phải admin
    }
    _clearFields();
    AutoRouter.of(context).push(const HomeQuizRoute());

  }

  void _register() {
    AutoRouter.of(context).push(const RegisterRoute());
  }

  void _clearFields() {
    _usernameController.clear();
    _passwordController.clear();
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
                  onPressed: _register,
                  child: const Text('Register')
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
