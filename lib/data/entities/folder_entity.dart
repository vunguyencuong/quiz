import 'package:floor/floor.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

@entity
class FolderEntity{
  FolderEntity({
    required this.name,
    this.path,
    required this.lastOpened,
    required this.bytes,
    this.size,
  });

  @primaryKey
  String id = const Uuid().v1();
  String name;
  String? path;
  int lastOpened;
  Uint8List bytes;
  int? size;
}
