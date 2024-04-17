import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quiz/app_router.dart';


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

  void _register() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Add your registration logic here
    print('Username: $username');
    print('Password: $password');

    // For now, just clear the fields after registration attempt
    _usernameController.clear();
    _passwordController.clear();

    AutoRouter.of(context).push(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _register,
          child: Text('Register'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
