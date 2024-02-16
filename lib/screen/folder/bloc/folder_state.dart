part of 'folder_bloc.dart';

abstract class FolderState {
  FolderState({required this.parentId});
  final String parentId;
}

class FolderInitial extends FolderState {
  FolderInitial({required super.parentId});

}
class FolderLoadInProgress extends FolderState {
  FolderLoadInProgress({required super.parentId});
}

class FolderLoadSuccess extends FolderState {
  FolderLoadSuccess({required this.listFile, required super.parentId});
  final List<FileEntity> listFile;
}
