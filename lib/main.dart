import 'package:flutter/material.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:smart_printer/route/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
