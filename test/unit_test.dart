import 'package:smart_printer/data/app_database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_printer/data/entities/file_entity.dart';
import 'package:smart_printer/data/repositories/file_repository.dart';

main() async {
  final AppDatabase appDatabase = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
  final FileRepository fileRepository = appDatabase.fileRepository;
  test('AppDatabase', () {
    expect(appDatabase, isA<AppDatabase>());
  });

  test('FileRepository', () {
    expect(fileRepository, isA<FileRepository>());
  });

  //await fileRepository.
  test('Insert root', () async {
    final root = FileEntity.root();
    await fileRepository.insertFile(root);
    final files = await fileRepository.getRecentFiles();
    for (var file in files) {
      print('${file.id} ${file.name} ${file.type} ${file.path} ${file.parentId} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(files.length, 1);
  });

  test('New folder in root', () async {
    final folder = FileEntity(name: 'folder', type: FileType.folder, lastOpened: DateTime.now().millisecondsSinceEpoch, parentId: 'root');
    await fileRepository.insertFile(folder);
    final files = await fileRepository.getRecentFiles();
    for (var file in files) {
      print('${file.id} ${file.name} ${file.path} ${file.parentId} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(files.length, 2);
  });

  test('Get children of root', () async {
    final children = await fileRepository.getFilesByParentId('root');
    for (var file in children) {
      print('${file.id} ${file.name} ${file.path} ${file.parentId} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(children.length, 1);
  });

  test('New file in first folder of root', () async {
    final folder = (await fileRepository.getFilesByParentId('root')).first;
    final file = FileEntity(name: 'file', type: FileType.file, lastOpened: DateTime.now().millisecondsSinceEpoch, parentId: folder.id);
    await fileRepository.insertFile(file);
    final files = await fileRepository.getFilesByParentId(folder.id);
    for (var file in files) {
      print('${file.id} ${file.name} ${file.path} ${file.parentId} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(files.length, 1);
  });

  test('Move file to root', () async {
    final folder = (await fileRepository.getFilesByParentId('root')).first;
    final file = (await fileRepository.getFilesByParentId(folder.id)).first;
    file.parentId = 'root';
    await fileRepository.updateFile(file);
    final files = await fileRepository.getFilesByParentId(folder.id);
    for (var file in files) {
      print('${file.id} ${file.name} ${file.path} ${file.parentId} ${file.lastOpened} ${file.bytes} ${file.size}');
    }
    expect(files.length, 0);
  });
}
