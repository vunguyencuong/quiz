part of 'location_file_bloc.dart';

@immutable
abstract class LocationFileState {
  const LocationFileState({required this.parentId});
  final String parentId;
}

class LocationFileInitial extends LocationFileState {
  const LocationFileInitial({required super.parentId});
}
class LocationFileLoadInProgress extends LocationFileState {
  const LocationFileLoadInProgress({required super.parentId});
}
class LocationFileLoadSuccess extends LocationFileState {
  const LocationFileLoadSuccess({required this.listFile, required super.parentId});
  final List<FileEntity> listFile;
}
