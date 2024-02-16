import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/app_database/app_database.dart';
import '../../../data/entities/file_entity.dart';
import '../../../data/repositories/file_repository.dart';

part 'location_file_event.dart';

part 'location_file_state.dart';

class LocationFileBloc extends Bloc<LocationFileEvent, LocationFileState> {
  LocationFileBloc({
    required this.database,
  })  : fileRepository = database.fileRepository,
        super(const LocationFileInitial(parentId: 'root')) {
    on<LocationFileEventLoad>(_onLoad);
  }

  final AppDatabase database;
  final FileRepository fileRepository;

  Future<FutureOr<void>> _onLoad(LocationFileEventLoad event, Emitter<LocationFileState> emit) async {
    emit(LocationFileLoadInProgress(parentId: event.idFolder));
    final files = await fileRepository.getFilesByParentId(event.idFolder);
    emit(LocationFileLoadSuccess(listFile: files, parentId: event.idFolder));
  }
}
