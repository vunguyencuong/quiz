import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:smart_printer/data/entities/file_entity.dart';
import 'package:smart_printer/route/route.dart';

import 'bloc/location_file_bloc.dart';

@RoutePage()
class LocationFileScreen extends StatelessWidget {
  const LocationFileScreen({
    @PathParam('id') required this.id,
    super.key
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return LocationFileBloc(database: AppDatabase.getInstance())..add(LocationFileEventLoad(idFolder: id));
       },
      child: LocationFileUI(idFolder: id),
    );
  }
}
class LocationFileUI extends StatelessWidget {
   LocationFileUI({required this.idFolder, super.key});

  String idFolder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location File'),
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
            return ListView.builder(
              itemCount: state.listFile.length,
              itemBuilder: (context, index) {
                final file = state.listFile[index];
                return ListTile(
                  title: Text(state.listFile[index].name),
                  onTap: () async {
                    if(file.type == FileType.folder){
                      idFolder = await AutoRouter.of(context).push(LocationFileRoute(id: file.id)) as String;
                      AutoRouter.of(context).pop(idFolder);
                    }
                  },
                );
              },
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
}

