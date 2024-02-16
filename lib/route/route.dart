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
      page: HomeRoute.page,
      initial: true,
      path: '/',
    ),
    MaterialRoute(
        page: FolderRoute.page,
        path: '/folder/:idFolder',
    ),
    MaterialRoute(
        page: LocationFileRoute.page,
        path: '/location_file/:id',
    )
  ];
}