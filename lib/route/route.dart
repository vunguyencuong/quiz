import 'package:auto_route/auto_route.dart';
import 'package:smart_printer/screen/home/home_screen.dart';

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
  ];
}