import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app_router.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: "Username",
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        const SizedBox(height: 20),
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
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
