import 'dart:async';

import 'package:floor/floor.dart';
import 'package:smart_printer/data/repositories/folder_repository.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter/services.dart';

import '../entities/file_entity.dart';
import '../entities/folder_entity.dart';
import '../repositories/file_repository.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [FileEntity, FolderEntity])
abstract class AppDatabase extends FloorDatabase {
  static AppDatabase? _instance;

  static AppDatabase getInstance() {
    return _instance!;
  }

  FileRepository get fileRepository;
  FolderRepository get folderRepository;

  static Future<void> initDatabase() async {
    _instance = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
