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

  FolderRepository? _folderRepositoryInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `FileEntity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `path` TEXT, `idFolder` TEXT, `lastOpened` INTEGER NOT NULL, `bytes` BLOB NOT NULL, `size` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FolderEntity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `path` TEXT, `lastOpened` INTEGER NOT NULL, `bytes` BLOB NOT NULL, `size` INTEGER, PRIMARY KEY (`id`))');

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

  @override
  FolderRepository get folderRepository {
    return _folderRepositoryInstance ??=
        _$FolderRepository(database, changeListener);
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
                  'name': item.name,
                  'path': item.path,
                  'idFolder': item.idFolder,
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
                  'name': item.name,
                  'path': item.path,
                  'idFolder': item.idFolder,
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
                  'name': item.name,
                  'path': item.path,
                  'idFolder': item.idFolder,
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
            name: row['name'] as String,
            path: row['path'] as String?,
            idFolder: row['idFolder'] as String?,
            lastOpened: row['lastOpened'] as int,
            bytes: row['bytes'] as Uint8List,
            size: row['size'] as int?));
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

class _$FolderRepository extends FolderRepository {
  _$FolderRepository(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _folderEntityInsertionAdapter = InsertionAdapter(
            database,
            'FolderEntity',
            (FolderEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                }),
        _folderEntityUpdateAdapter = UpdateAdapter(
            database,
            'FolderEntity',
            ['id'],
            (FolderEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                }),
        _folderEntityDeletionAdapter = DeletionAdapter(
            database,
            'FolderEntity',
            ['id'],
            (FolderEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastOpened': item.lastOpened,
                  'bytes': item.bytes,
                  'size': item.size
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FolderEntity> _folderEntityInsertionAdapter;

  final UpdateAdapter<FolderEntity> _folderEntityUpdateAdapter;

  final DeletionAdapter<FolderEntity> _folderEntityDeletionAdapter;

  @override
  Future<List<FolderEntity>> getRecentFolders() async {
    return _queryAdapter.queryList(
        'SELECT * FROM FolderEntity ORDER BY lastOpened DESC',
        mapper: (Map<String, Object?> row) => FolderEntity(
            name: row['name'] as String,
            path: row['path'] as String?,
            lastOpened: row['lastOpened'] as int,
            bytes: row['bytes'] as Uint8List,
            size: row['size'] as int?));
  }

  @override
  Future<void> insertFolder(FolderEntity folder) async {
    await _folderEntityInsertionAdapter.insert(
        folder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFolder(FolderEntity folder) async {
    await _folderEntityUpdateAdapter.update(folder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFolder(FolderEntity folder) async {
    await _folderEntityDeletionAdapter.delete(folder);
  }
}
