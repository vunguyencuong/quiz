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
  }

  final AppDatabase database;
  final FileRepository fileRepository;


  Future<FutureOr<void>> _onLoad(FolderEventLoad event, Emitter<FolderState> emit) async {
    emit(FolderLoadInProgress(parentId: event.idFolder));
    final files = await fileRepository.getFilesByParentId(event.idFolder);
    emit(FolderLoadSuccess(listFile: files, parentId: event.idFolder));
  }

}
