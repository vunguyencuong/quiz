import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_printer/screen/home/home_screen.dart';
import 'package:smart_printer/screen/location_file/location_file_screen.dart';

import '../screen/folder/folder_screen.dart';


part 'route.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    MaterialRoute(
      page: LoginRoute.page,
      initial: true,
      path: '/login',
    ),
    MaterialRoute(
        page: FolderRoute.page,
        path: '/folder/:idFolder/:name',
    ),
    MaterialRoute(
        page: LocationFileRoute.page,
        path: '/location_file/:id/:idFolderNeedToMove/:name',
    ),
    MaterialRoute(
      page: CompletedRoute.page,
      path: '/completed',
    ),
    MaterialRoute(
      page: CreateQuizRoute.page,
      path: '/createQuiz',
    ),
    MaterialRoute(
      page: HomeQuizRoute.page,
      path: '/homeQuiz',
    ),
    MaterialRoute(
      page: QuizRoute.page,
      path: '/quiz',
    ),
    MaterialRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
  ];
}