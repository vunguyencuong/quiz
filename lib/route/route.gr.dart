// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});
  @override
  final Map<String, PageFactory> pagesMap = {
    CompletedRoute.name: (routeData) {
      final args = routeData.argsAs<CompletedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompletedScreen(result: args.resultResponse,),
      );
    },
    CreateQuizRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreateQuizScreen(),
      );
    },
    FolderRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<FolderRouteArgs>(
          orElse: () => FolderRouteArgs(
                idFolder: pathParams.getString('idFolder'),
                name: pathParams.getString('name'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FolderScreen(
          idFolder: args.idFolder,
          name: args.name,
          key: args.key,
        ),
      );
    },
    HomeQuizRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeQuizScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LocationFileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LocationFileRouteArgs>(
          orElse: () => LocationFileRouteArgs(
                id: pathParams.getString('id'),
                idFolderNeedToMove: pathParams.getString('idFolderNeedToMove'),
                name: pathParams.getString('name'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationFileScreen(
          id: args.id,
          idFolderNeedToMove: args.idFolderNeedToMove,
          name: args.name,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(),
      );
    },
    QuizRoute.name: (routeData) {
      final args = routeData.argsAs<QuizRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QuizScreen(id: args.id),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterScreen(),
      );
    },
  };
}

/// generated route for
/// [CompletedScreen]
class CompletedRoute extends PageRouteInfo<CompletedRouteArgs> {
  CompletedRoute({required ResultResponse resultResponse})
      : super(
          CompletedRoute.name,
          args: CompletedRouteArgs(resultResponse: resultResponse),
        );

  static const String name = 'CompletedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}


/// generated route for
/// [CreateQuizScreen]
class CreateQuizRoute extends PageRouteInfo<void> {
  const CreateQuizRoute({List<PageRouteInfo>? children})
      : super(
          CreateQuizRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateQuizRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FolderScreen]
class FolderRoute extends PageRouteInfo<FolderRouteArgs> {
  FolderRoute({
    required String idFolder,
    required String name,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          FolderRoute.name,
          args: FolderRouteArgs(
            idFolder: idFolder,
            name: name,
            key: key,
          ),
          rawPathParams: {
            'idFolder': idFolder,
            'name': name,
          },
          initialChildren: children,
        );

  static const String name = 'FolderRoute';

  static const PageInfo<FolderRouteArgs> page = PageInfo<FolderRouteArgs>(name);
}

class FolderRouteArgs {
  const FolderRouteArgs({
    required this.idFolder,
    required this.name,
    this.key,
  });

  final String idFolder;

  final String name;

  final Key? key;

  @override
  String toString() {
    return 'FolderRouteArgs{idFolder: $idFolder, name: $name, key: $key}';
  }
}

/// generated route for
/// [HomeQuizScreen]
class HomeQuizRoute extends PageRouteInfo<void> {
  const HomeQuizRoute({List<PageRouteInfo>? children})
      : super(
          HomeQuizRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeQuizRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LocationFileScreen]
class LocationFileRoute extends PageRouteInfo<LocationFileRouteArgs> {
  LocationFileRoute({
    required String id,
    required String idFolderNeedToMove,
    required String name,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LocationFileRoute.name,
          args: LocationFileRouteArgs(
            id: id,
            idFolderNeedToMove: idFolderNeedToMove,
            name: name,
            key: key,
          ),
          rawPathParams: {
            'id': id,
            'idFolderNeedToMove': idFolderNeedToMove,
            'name': name,
          },
          initialChildren: children,
        );

  static const String name = 'LocationFileRoute';

  static const PageInfo<LocationFileRouteArgs> page =
      PageInfo<LocationFileRouteArgs>(name);
}

class LocationFileRouteArgs {
  const LocationFileRouteArgs({
    required this.id,
    required this.idFolderNeedToMove,
    required this.name,
    this.key,
  });

  final String id;

  final String idFolderNeedToMove;

  final String name;

  final Key? key;

  @override
  String toString() {
    return 'LocationFileRouteArgs{id: $id, idFolderNeedToMove: $idFolderNeedToMove, name: $name, key: $key}';
  }
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}


/// generated route for
/// [QuizScreen]
class QuizRoute extends PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(id: id),
          rawPathParams: {
            'id': id,
          },
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static const PageInfo<QuizRouteArgs> page = PageInfo<QuizRouteArgs>(name);
}


class CompletedRouteArgs {
  const CompletedRouteArgs({required this.resultResponse});

  final ResultResponse resultResponse;
}

class QuizRouteArgs {
  const QuizRouteArgs({
    required this.id,
  });

  final String id;

  @override
  String toString() {
    return 'QuizRouteArgs{id: $id}';
  }
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
