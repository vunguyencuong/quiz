import 'package:floor/floor.dart';
import 'package:flutter/services.dart';

@entity
class FileEntity {
  FileEntity({
    required this.name,
    this.path,
    required this.lastOpened,
    required this.bytes,
    this.size,
  });

  @primaryKey
  String name;
  String? path;
  int lastOpened;
  Uint8List bytes;
  int? size;
}
