part of 'folder_bloc.dart';

abstract class FolderEvent {
  const FolderEvent();
}
class FolderEventLoad extends FolderEvent {
  FolderEventLoad({required this.idFolder});
  String idFolder;
}



