import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:smart_printer/route/route.dart';
import '../../data/entities/file_entity.dart';
import 'bloc/folder_bloc.dart';

@RoutePage()
class FolderScreen extends StatelessWidget {
  FolderScreen({@PathParam('idFolder') required this.idFolder, super.key});

  String idFolder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          FolderBloc(database: AppDatabase.getInstance())
            ..add(FolderEventLoad(idFolder: idFolder)),
      child: FolderScreenUI(idFolder: idFolder),
    );
  }
}

class FolderScreenUI extends StatelessWidget {
  FolderScreenUI({required this.idFolder, super.key});
  String idFolder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(idFolder),
        ),
        body: BlocConsumer<FolderBloc, FolderState>(
          builder: (BuildContext context, FolderState state) {
            if (state is FolderLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FolderLoadSuccess) {
              return ListView.builder(
                itemCount: state.listFile.length,
                itemBuilder: (BuildContext context, int index) {
                  final file = state.listFile[index];
                  return ListTile(
                    title: Text(file.name),
                    onTap: () {
                      if (file.type == FileType.folder) {
                        AutoRouter.of(context)
                            .push(FolderRoute(idFolder: file.id));
                      } else {
                        // AutoRouter.of(context).push('/file/${file.id}');
                      }
                    },
                  );
                },
              );
            }
            return const Center(
              child: Text('Error'),
            );
          },
          listener: (BuildContext context, FolderState state) {},
        ));
  }
}
