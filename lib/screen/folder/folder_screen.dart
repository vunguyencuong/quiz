import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_printer/data/entities/file_entity.dart';
import 'package:smart_printer/data/entities/folder_entity.dart';

@RoutePage()
class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> lists = [
      FileEntity(
          name: "File 1",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FolderEntity(
          name: "Folder 1",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FileEntity(
          name: "File 2",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FolderEntity(
          name: "Folder 2",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FileEntity(
          name: "File 3",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FolderEntity(
          name: "Folder 3",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FileEntity(
          name: "File 4",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
      FolderEntity(
          name: "Folder 4",
          lastOpened: DateTime.now().millisecondsSinceEpoch,
          bytes: Uint8List(0),
          size: 0),
    ];
    return Scaffold(
      body: ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, index) {
            if (lists[index] is FileEntity) {
              return ListTile(
                leading: const Icon(FontAwesomeIcons.file),
                trailing: const Icon(FontAwesomeIcons.ellipsis),
                subtitle: Text("Last opened: ${DateTime.fromMillisecondsSinceEpoch(lists[index].lastOpened)}"),
                title: Text(lists[index].name),
              );
            } else {
              return ListTile(
                leading: const Icon(FontAwesomeIcons.folder),
                trailing: const Icon(FontAwesomeIcons.ellipsis),
                title: Text(lists[index].name),
              );
            }
          }),
    );
  }
}
