part of 'location_file_bloc.dart';


abstract class LocationFileEvent {
  const LocationFileEvent();
}
class LocationFileEventLoad extends LocationFileEvent {
  LocationFileEventLoad({required this.idFolder});
  String idFolder;
}
