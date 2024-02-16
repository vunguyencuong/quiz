part of 'folder_bloc.dart';

abstract class FolderEvent {
  const FolderEvent();
}
class FolderEventLoad extends FolderEvent {
  FolderEventLoad({required this.idFolder});
  String idFolder;
}
class FolderEventSave extends FolderEvent {
  FolderEventSave({required this.fileEntity});
  FileEntity fileEntity;
}
class FolderEventDelete extends FolderEvent {
  FolderEventDelete({required this.fileEntity});
  FileEntity fileEntity;
}
class FolderEventInsert extends FolderEvent {
  FolderEventInsert({required this.fileEntity});
  FileEntity fileEntity;
}
class FolderEventMove extends FolderEvent {
  FolderEventMove({required this.fileEntity, required this.idFolder});
  FileEntity fileEntity;
  String idFolder;
}



