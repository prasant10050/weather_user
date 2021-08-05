part of 'app_permission_bloc.dart';

abstract class AppPermissionEvent extends Equatable {
  const AppPermissionEvent();
}

class CheckLocationServiceEnable extends AppPermissionEvent {
  final bool serviceEnabled;

  CheckLocationServiceEnable({this.serviceEnabled = false});

  @override
  List<Object?> get props => [
        serviceEnabled,
      ];
}

class RequestLocationService extends AppPermissionEvent {
  final bool? serviceEnabled;

  RequestLocationService({this.serviceEnabled = false});

  @override
  List<Object?> get props => [
        serviceEnabled,
      ];
}

class CheckLocationPermissionEnable extends AppPermissionEvent {
  final PermissionStatus? permissionGranted;

  CheckLocationPermissionEnable({this.permissionGranted});

  @override
  List<Object?> get props => [
        permissionGranted,
      ];
}

class RequestLocationPermission extends AppPermissionEvent {
  final PermissionStatus? permissionGranted;

  RequestLocationPermission({this.permissionGranted});

  @override
  List<Object?> get props => [
        permissionGranted,
      ];
}

class GetCurrentLocation extends AppPermissionEvent {
  final LocationData? location;
  final String? error;

  GetCurrentLocation({
    this.location,
    this.error,
  });

  @override
  List<Object?> get props => [
        location,
        error,
      ];
}

class AddMarkerEvent extends AppPermissionEvent {
  final LatLng? latLng;
  final String? markerID;

  AddMarkerEvent({
    this.latLng,
    this.markerID,
  });

  @override
  List<Object?> get props => [
        latLng,
        markerID,
      ];
}

class UpdateLocationEvent extends AppPermissionEvent {
  final LatLng? latLng;
  final String place;

  UpdateLocationEvent({
    this.latLng,
    this.place = '',
  });

  @override
  List<Object?> get props => [
        latLng,
        place,
      ];
}
