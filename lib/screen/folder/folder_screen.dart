import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:smart_printer/route/route.dart';

import '../../data/entities/file_entity.dart';
import 'bloc/folder_bloc.dart';

@RoutePage()
class FolderScreen extends StatelessWidget {
  FolderScreen({
    @PathParam('idFolder') required this.idFolder,
    @PathParam('name') required this.name,
    super.key});

  String idFolder;
  String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          FolderBloc(database: AppDatabase.getInstance())
            ..add(FolderEventLoad(idFolder: idFolder)),
      child: FolderScreenUI(name: name, idFolder: idFolder),
    );
  }
}

class FolderScreenUI extends StatelessWidget {
  FolderScreenUI({
    required this.idFolder,
    required this.name,
    super.key});

  String idFolder;
  String name;
  bool isChange = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          leading: InkWell(
            child: const Center(child: FaIcon(FontAwesomeIcons.arrowLeft)),
            onTap: () {
              AutoRouter.of(context).pop(isChange);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var newFile = await _insertFileDialog(context, FileEntity(
              name: 'New Folder',
              type: FileType.folder,
              lastOpened: DateTime.now().millisecondsSinceEpoch,
              parentId: idFolder,
            ));
            if (newFile != null) {
              context.read<FolderBloc>().add(
                    FolderEventInsert(
                      fileEntity: newFile,
                    ),
              );
            }
          },
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        body: BlocConsumer<FolderBloc, FolderState>(
          builder: (BuildContext context, FolderState state) {
            if (state is FolderLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FolderLoadSuccess) {
              if(state.listFile.isEmpty){
                return const Center(
                  child: Text('Empty'),
                );
              }
              return RefreshIndicator(
                onRefresh: () {
                  context.read<FolderBloc>().add(
                    FolderEventLoad(idFolder: idFolder),
                  );
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  itemCount: state.listFile.length,
                  itemBuilder: (BuildContext context, int index) {
                    final file = state.listFile[index];
                    return ListTile(
                      title: Text(file.name),
                      leading: file.type == FileType.folder
                          ? const FaIcon(FontAwesomeIcons.folder)
                          : const FaIcon(FontAwesomeIcons.file),
                      trailing: InkWell(
                        child: const FaIcon(FontAwesomeIcons.ellipsis),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const FaIcon(FontAwesomeIcons
                                        .upRightAndDownLeftFromCenter),
                                    title: const Text('Move'),
                                    onTap: () async {
                                      var parentId = await AutoRouter.of(context).push(
                                        LocationFileRoute(id: 'root', idFolderNeedToMove: file.id, name: "Root"),
                                      );
                                      if (parentId != null) {
                                        file.parentId = parentId as String?;
                                        Navigator.of(context).pop(['move', file]);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const FaIcon(FontAwesomeIcons.edit),
                                    title: const Text('Edit'),
                                    onTap: () async {
                                      var newFile = await _showDialog(context, file);
                                      if (newFile != null) {
                                        Navigator.of(context).pop(['edit', file]);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const FaIcon(FontAwesomeIcons.trash),
                                    title: const Text('Delete'),
                                    onTap: () async {
                                      var choice = await _showChoiceDialog(context, file);
                                      if(choice != null){
                                        Navigator.of(context).pop(['delete', file]);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((value) => {
                                if (value != null){
                                  if (value[0] == 'edit'){
                                        context.read<FolderBloc>().add(
                                              FolderEventSave(
                                                fileEntity: value[1],
                                              ),
                                        ),
                                  } else if (value[0] == 'delete'){
                                        context.read<FolderBloc>().add(
                                              FolderEventDelete(
                                                fileEntity: value[1],
                                              ),
                                        ),
                                    }
                                    else if (value[0] == 'move'){
                                      context.read<FolderBloc>().add(
                                        FolderEventMove(
                                          fileEntity: value[1],
                                          idFolder: idFolder,
                                        ),
                                      ),
                                      isChange = true,
                                    }
                                  }
                              });
                        },
                      ),
                      onTap: () async {
                        if (file.type == FileType.folder) {
                          var result = await AutoRouter.of(context)
                              .push(FolderRoute(name: file.name, idFolder: file.id));
                          if(result == true){
                            isChange = true;
                            context.read<FolderBloc>().add(
                              FolderEventLoad(idFolder: idFolder),
                            );
                          }
                        } else {
                          // AutoRouter.of(context).push('/file/${file.id}');
                        }
                      },
                    );
                  },
                ),
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

Future _showChoiceDialog(BuildContext context, FileEntity file) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure to delete this file?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('delete');
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  ).then(
    (value) {
      return value;
    },
  );
}

Future _showDialog(BuildContext context, FileEntity file) {
  TextEditingController controller = TextEditingController(text: file.name);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Name',
              ),
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                file.name = controller.text;
                Navigator.of(context).pop(file);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    },
  ).then(
    (value) {
      return value;
    },
  );
}
Future _insertFileDialog(BuildContext context, FileEntity file) {
  TextEditingController controller = TextEditingController(text: "Name");
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      value: 'folder',
      child: Text('Folder'),
    ),
    const DropdownMenuItem(
      value: 'file',
      child: Text('File'),
    ),
  ];
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Insert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Name',
              ),
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton(
              isExpanded: true,
              items: items,
              onChanged: (value) {
                file.type = value == 'folder' ? FileType.folder : FileType.file;
              },
              value: file.type == FileType.folder ? 'folder' : 'file',
            ),
            ElevatedButton(
              onPressed: () {
                file.name = controller.text;
                Navigator.of(context).pop(file);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    },
  ).then(
    (value) {
      return value;
    },
  );
}

