import 'package:floor/floor.dart';

import '../entities/folder_entity.dart';

@dao
abstract class FolderRepository {
  @Query('SELECT * FROM FolderEntity ORDER BY lastOpened DESC')
  Future<List<FolderEntity>> getRecentFolders();

  @insert
  Future<void> insertFolder(FolderEntity folder);

  @update
  Future<void> updateFolder(FolderEntity folder);

  @delete
  Future<void> deleteFolder(FolderEntity folder);
}