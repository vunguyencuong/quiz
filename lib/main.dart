import 'dart:async';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:smart_printer/quiz/LoginScreen.dart';
import 'package:smart_printer/quiz/QuizScreen.dart';
import 'package:smart_printer/route/route.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:io' show Platform;

late SharedPreferences prefs;
late Dio dio;

String BASE_URL = "https://konk.portlycat.com:8443";
class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  StreamSubscription? _sub;
  String? _initialLink;

  MyApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!kIsWeb) return;
      initPlatformState();
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null &&
            uri.pathSegments.length > 1 &&
            uri.pathSegments.first == 'joinQuiz') {
          _appRouter.push(QuizRoute(id: uri.pathSegments[1]));
        }
      });
    });
  }

  Future<void> initPlatformState() async {
    String? initialLink;
    try {
      initialLink = await getInitialLink();
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } catch (err) {
      initialLink = 'Failed to get initial link: $err.';
    }

    _initialLink = initialLink;

    if (_initialLink != null) {
      Uri uri = Uri.parse(_initialLink!);
      if (uri.pathSegments.length > 1 && uri.pathSegments.first == 'joinQuiz') {
        _appRouter.push(QuizRoute(id: uri.pathSegments[1]));
      }
    }
  }

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
      builder: (context, router) {
        if (_initialLink != null) {
          Uri uri = Uri.parse(_initialLink!);
          if (uri.pathSegments.length > 1 &&
              uri.pathSegments.first == 'joinQuiz') {
            String? id = uri.pathSegments[1];
            _appRouter.push(QuizRoute(id: id));
          }
        }
        return router!;
      },
    );
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  dio = Dio();
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
  usePathUrlStrategy();
  Get.put(AuthController());
  Get.put(QuizController());
  runApp(MyApp());
}
