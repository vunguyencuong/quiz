import 'package:flutter/services.dart';
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

  test('Insert File', () async {
    final file = FileEntity(name: 'test', path: 'test', lastOpened: DateTime.now().millisecondsSinceEpoch, bytes: Uint8List(0), size: 0);
    await fileRepository.insertFile(file);
    final files = await fileRepository.getRecentFiles();
    expect(files.length, 1);
  });
}
