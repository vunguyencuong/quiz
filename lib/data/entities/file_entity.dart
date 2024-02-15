import 'package:floor/floor.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

enum FileType { folder, file }

@entity
class FileEntity {
  FileEntity({
    String? id,
    required this.name,
    this.type = FileType.file,
    this.path,
    this.parentId,
    required this.lastOpened,
    this.bytes,
    this.size,
  }) {
    this.id = id ?? const Uuid().v1();
  }

  factory FileEntity.root() {
    return FileEntity(
      name: 'root',
      lastOpened: DateTime.now().millisecondsSinceEpoch,
      type: FileType.folder,
    )..id = 'root';
  }

  @primaryKey
  late String id;
  FileType type;
  String name;
  String? path;
  String? parentId;
  int lastOpened;
  Uint8List? bytes;
  int? size;
}
