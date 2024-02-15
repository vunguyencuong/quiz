import 'package:floor/floor.dart';
import 'package:flutter/services.dart';

@entity
class FileEntity {
  FileEntity({
    this.id,
    required this.name,
    this.path,
    this.idFolder,
    required this.lastOpened,
    required this.bytes,
    this.size,
  });

  @PrimaryKey(autoGenerate: true)
  int? id;
  String name;
  String? path;
  int? idFolder;
  int lastOpened;
  Uint8List bytes;
  int? size;
}
