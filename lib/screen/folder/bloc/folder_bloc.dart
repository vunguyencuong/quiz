import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:smart_printer/data/repositories/file_repository.dart';
import '../../../data/app_database/app_database.dart';
import '../../../data/entities/file_entity.dart';

part 'folder_event.dart';

part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc({required this.database})
      : fileRepository = database.fileRepository,
        super(FolderInitial(parentId: 'root')) {
    on<FolderEventLoad>(_onLoad);
    on<FolderEventSave>(_onSave);
    on<FolderEventDelete>(_onDelete);
    on<FolderEventInsert>(_onInsert);
  }

  final AppDatabase database;
  final FileRepository fileRepository;


  Future<FutureOr<void>> _onLoad(FolderEventLoad event, Emitter<FolderState> emit) async {
    emit(FolderLoadInProgress(parentId: event.idFolder));
    final files = await fileRepository.getFilesByParentId(event.idFolder);
    if(files.isEmpty){
      print('Empty');
    }
    emit(FolderLoadSuccess(listFile: files, parentId: event.idFolder));
  }

  Future<FutureOr<void>> _onSave(FolderEventSave event, Emitter<FolderState> emit) async {
    await fileRepository.updateFile(event.fileEntity);
    final files = await fileRepository.getFilesByParentId(event.fileEntity.parentId!);
    emit(FolderLoadSuccess(listFile: files, parentId: event.fileEntity.parentId!));
  }

  Future<FutureOr<void>> _onDelete(FolderEventDelete event, Emitter<FolderState> emit) async {
    fileRepository.deleteFile(event.fileEntity);
    final files = await fileRepository.getFilesByParentId(event.fileEntity.parentId!);
    emit(FolderLoadSuccess(listFile: files, parentId: event.fileEntity.parentId!));
  }


  Future<FutureOr<void>> _onInsert(FolderEventInsert event, Emitter<FolderState> emit) async {
    await fileRepository.insertFile(event.fileEntity);
    final files = await fileRepository.getFilesByParentId(event.fileEntity.parentId!);
    emit(FolderLoadSuccess(listFile: files, parentId: event.fileEntity.parentId!));
  }
}
