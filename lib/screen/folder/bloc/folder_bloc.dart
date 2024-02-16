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
    on<FolderEventMove>(_onMove);
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
    add(FolderEventLoad(idFolder: event.fileEntity.parentId!) );
  }

  Future<FutureOr<void>> _onDelete(FolderEventDelete event, Emitter<FolderState> emit) async {
    // remove folder and all child folder
    final listFile = await fileRepository.getFilesByParentId(event.fileEntity.id);
    if(listFile.isEmpty){
      await fileRepository.deleteFile(event.fileEntity);
      add(FolderEventLoad(idFolder: event.fileEntity.parentId!) );
    }
    else{
      for (var file in listFile) {
        add(FolderEventDelete(fileEntity: file));
      }
      await fileRepository.deleteFile(event.fileEntity);
      add(FolderEventLoad(idFolder: event.fileEntity.parentId!) );
    }
  }


  Future<FutureOr<void>> _onInsert(FolderEventInsert event, Emitter<FolderState> emit) async {
    await fileRepository.insertFile(event.fileEntity);
    add(FolderEventLoad(idFolder: event.fileEntity.parentId!));
  }

  Future<FutureOr<void>> _onMove(FolderEventMove event, Emitter<FolderState> emit) async {
    await fileRepository.updateFile(event.fileEntity);
    add(FolderEventLoad(idFolder: event.idFolder));
  }
}
