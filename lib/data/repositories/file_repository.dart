import 'package:floor/floor.dart';

import '../entities/file_entity.dart';

@dao
abstract class FileRepository {
  @Query('SELECT * FROM FileEntity ORDER BY lastOpened DESC')
  Future<List<FileEntity>> getRecentFiles();

  @Query('SELECT * FROM FileEntity WHERE parentId = :parentId ORDER BY lastOpened DESC')
  Future<List<FileEntity>> getFilesByParentId(String parentId);

  @insert
  Future<void> insertFile(FileEntity file);

  @update
  Future<void> updateFile(FileEntity file);

  @delete
  Future<void> deleteFile(FileEntity file);
}
