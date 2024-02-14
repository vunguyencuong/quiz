import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter/services.dart';

import '../entities/file_entity.dart';
import '../repositories/file_repository.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [FileEntity])
abstract class AppDatabase extends FloorDatabase {
  static AppDatabase? _instance;

  static AppDatabase getInstance() {
    return _instance!;
  }

  FileRepository get fileRepository;

  static Future<void> initDatabase() async {
    _instance = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
