import 'package:flutter/services.dart';
import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_printer/data/entities/file_entity.dart';
import 'package:smart_printer/data/entities/folder_entity.dart';
import 'package:smart_printer/data/repositories/file_repository.dart';
import 'package:smart_printer/data/repositories/folder_repository.dart';

main() async {
  final AppDatabase appDatabase = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
  final FileRepository fileRepository = appDatabase.fileRepository;
  final FolderRepository folderRepository = appDatabase.folderRepository;
  test('AppDatabase', () {
    expect(appDatabase, isA<AppDatabase>());
  });

  test('FileRepository', () {
    expect(fileRepository, isA<FileRepository>());
  });

  test('FolderRepository', () {
    expect(folderRepository, isA<FolderRepository>());
  });

  //await fileRepository.
  test('Insert File', () async {
    final file = FileEntity(name: 'test', path: 'test', lastOpened: DateTime.now().millisecondsSinceEpoch, bytes: Uint8List(0), size: 0);
    await fileRepository.insertFile(file);
    final file2 = FileEntity(name: 'test2', path: 'test2', lastOpened: DateTime.now().millisecondsSinceEpoch, bytes: Uint8List(0), size: 0);
    await fileRepository.insertFile(file2);
    final files = await fileRepository.getRecentFiles();
    for (var file in files) {
      print('${file.id} ${file.name} ${file.path} ${file.idFolder} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(files.length, 1);
  });

  test('Insert Folder', () async {
    final folder = FolderEntity(name: "test", lastOpened: 0, bytes: Uint8List(0));
    await folderRepository.insertFolder(folder);

    final folder2 = FolderEntity(name: "test2", lastOpened: 0, bytes: Uint8List(0));
    await folderRepository.insertFolder(folder2);

    final folders = await folderRepository.getRecentFolders();
    for (var folder in folders) {
      print('${folder.id} ${folder.name} ${folder.lastOpened} ${folder.bytes} ${folder.size}');
    }
    expect(folders.length, 1);

  });
}
