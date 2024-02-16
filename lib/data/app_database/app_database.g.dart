// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FileRepository? _fileRepositoryInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FileEntity` (`id` TEXT NOT NULL, `type` INTEGER NOT NULL, `name` TEXT NOT NULL, `path` TEXT, `parentId` TEXT, `lastOpened` INTEGER NOT NULL, `bytes` BLOB, `size` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FileRepository get fileRepository {
    return _fileRepositoryInstance ??=
        _$FileRepository(database, changeListener);
  }
}

class _$FileRepository extends FileRepository {
  _$FileRepository(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fileEntityInsertionAdapter = InsertionAdapter(
            database,
            'FileEntity',
            (FileEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'name': item.name,
                  'path': item.path,
                  'parentId': item.parentId,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                }),
        _fileEntityUpdateAdapter = UpdateAdapter(
            database,
            'FileEntity',
            ['id'],
            (FileEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'name': item.name,
                  'path': item.path,
                  'parentId': item.parentId,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                }),
        _fileEntityDeletionAdapter = DeletionAdapter(
            database,
            'FileEntity',
            ['id'],
            (FileEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'name': item.name,
                  'path': item.path,
                  'parentId': item.parentId,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FileEntity> _fileEntityInsertionAdapter;

  final UpdateAdapter<FileEntity> _fileEntityUpdateAdapter;

  final DeletionAdapter<FileEntity> _fileEntityDeletionAdapter;

  @override
  Future<List<FileEntity>> getRecentFiles() async {
    return _queryAdapter.queryList(
        'SELECT * FROM FileEntity ORDER BY lastOpened DESC',
        mapper: (Map<String, Object?> row) => FileEntity(
            id: row['id'] as String?,
            name: row['name'] as String,
            type: FileType.values[row['type'] as int],
            path: row['path'] as String?,
            parentId: row['parentId'] as String?,
            lastOpened: row['lastOpened'] as int,
            bytes: row['bytes'] as Uint8List?,
            size: row['size'] as int?));
  }

  @override
  Future<List<FileEntity>> getFilesByParentId(String parentId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FileEntity WHERE parentId = ?1 ORDER BY lastOpened DESC',
        mapper: (Map<String, Object?> row) => FileEntity(
            id: row['id'] as String?,
            name: row['name'] as String,
            type: FileType.values[row['type'] as int],
            path: row['path'] as String?,
            parentId: row['parentId'] as String?,
            lastOpened: row['lastOpened'] as int,
            bytes: row['bytes'] as Uint8List?,
            size: row['size'] as int?),
        arguments: [parentId]);
  }

  @override
  Future<FileEntity?> getFileById(String id) async {
    return _queryAdapter.query('SELECT * FROM FileEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FileEntity(
            id: row['id'] as String?,
            name: row['name'] as String,
            type: FileType.values[row['type'] as int],
            path: row['path'] as String?,
            parentId: row['parentId'] as String?,
            lastOpened: row['lastOpened'] as int,
            bytes: row['bytes'] as Uint8List?,
            size: row['size'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllFile() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FileEntity');
  }

  @override
  Future<void> insertFile(FileEntity file) async {
    await _fileEntityInsertionAdapter.insert(file, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFile(FileEntity file) async {
    await _fileEntityUpdateAdapter.update(file, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFile(FileEntity file) async {
    await _fileEntityDeletionAdapter.delete(file);
  }
}
