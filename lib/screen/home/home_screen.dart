import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: const Center(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AutoRouter.of(context).pushNamed('/folder/root/Root Folder');
          },
        )
      ),
    );
  }
}
