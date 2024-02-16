import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:smart_printer/data/entities/file_entity.dart';
import 'package:smart_printer/route/route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bloc/location_file_bloc.dart';

@RoutePage()
class LocationFileScreen extends StatelessWidget {
  const LocationFileScreen({
    @PathParam('id') required this.id,
    @PathParam('idFolderNeedToMove') required this.idFolderNeedToMove,
    @PathParam('name') required this.name,
    super.key
  });
  final String id;
  final String idFolderNeedToMove;
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return LocationFileBloc(database: AppDatabase.getInstance())..add(LocationFileEventLoad(idFolder: id));
       },
      child: LocationFileUI(idFolder: id, idFolderNeedToMove: idFolderNeedToMove,
        name: name,
      ),
    );
  }
}
class LocationFileUI extends StatelessWidget {
   LocationFileUI({
     required this.idFolder,
     required this.idFolderNeedToMove,
     required this.name,
     super.key});

  String idFolder;
   final String idFolderNeedToMove;
   String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        // leading: InkWell(
        //   child: const Center(child: FaIcon(FontAwesomeIcons.arrowLeft)),
        //   onTap: () {
        //     AutoRouter.of(context).pop();
        //   },
        // )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          AutoRouter.of(context).pop(idFolder);
        },
        child: const Icon(Icons.done),
      ),
      body: BlocBuilder<LocationFileBloc, LocationFileState>(
        builder: (context, state) {
          if (state is LocationFileLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LocationFileLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () {
                context.read<LocationFileBloc>().add(LocationFileEventLoad(idFolder: idFolder));
                return Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: state.listFile.length,
                itemBuilder: (context, index) {
                  final file = state.listFile[index];
                  return ListTile(
                    title: Text(state.listFile[index].name),
                    onTap: () async {
                      if(file.type == FileType.folder){
                        if(file.id == idFolderNeedToMove){
                          _showDialog(context, 'Cannot move to this folder');
                          return;
                        }
                        var result = await AutoRouter.of(context).push(
                            LocationFileRoute(
                              id: file.id, idFolderNeedToMove: idFolderNeedToMove,
                              name: file.name,
                            )) ;
                        if(result != null) {
                          idFolder = result as String;
                          AutoRouter.of(context).pop(idFolder);
                        }


                      }
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Empty'),
            );
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(s),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

