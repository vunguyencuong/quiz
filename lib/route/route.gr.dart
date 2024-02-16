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
    FolderRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<FolderRouteArgs>(
          orElse: () =>
              FolderRouteArgs(idFolder: pathParams.getString('idFolder')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FolderScreen(
          idFolder: args.idFolder,
          key: args.key,
        ),
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
          orElse: () => LocationFileRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LocationFileScreen(
          id: args.id,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [FolderScreen]
class FolderRoute extends PageRouteInfo<FolderRouteArgs> {
  FolderRoute({
    required String idFolder,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          FolderRoute.name,
          args: FolderRouteArgs(
            idFolder: idFolder,
            key: key,
          ),
          rawPathParams: {'idFolder': idFolder},
          initialChildren: children,
        );

  static const String name = 'FolderRoute';

  static const PageInfo<FolderRouteArgs> page = PageInfo<FolderRouteArgs>(name);
}

class FolderRouteArgs {
  const FolderRouteArgs({
    required this.idFolder,
    this.key,
  });

  final String idFolder;

  final Key? key;

  @override
  String toString() {
    return 'FolderRouteArgs{idFolder: $idFolder, key: $key}';
  }
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
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LocationFileRoute.name,
          args: LocationFileRouteArgs(
            id: id,
            key: key,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'LocationFileRoute';

  static const PageInfo<LocationFileRouteArgs> page =
      PageInfo<LocationFileRouteArgs>(name);
}

class LocationFileRouteArgs {
  const LocationFileRouteArgs({
    required this.id,
    this.key,
  });

  final String id;

  final Key? key;

  @override
  String toString() {
    return 'LocationFileRouteArgs{id: $id, key: $key}';
  }
}
