import 'package:floor/floor.dart';
import 'package:flutter/services.dart';

@entity
class FolderEntity{
  FolderEntity({
    this.id,
    required this.name,
    this.path,
    required this.lastOpened,
    required this.bytes,
    this.size,
  });

  @PrimaryKey(autoGenerate: true)
  int? id;
  String name;
  String? path;
  int lastOpened;
  Uint8List bytes;
  int? size;
}
