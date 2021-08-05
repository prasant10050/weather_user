part of 'app_permission_bloc.dart';

abstract class AppPermissionState extends Equatable {
  const AppPermissionState();
}

class AppPermissionInitial extends AppPermissionState {
  @override
  List<Object> get props => [];
}

class CheckLocationServiceEnableState extends AppPermissionState {
  final bool? serviceEnabled;

  CheckLocationServiceEnableState({this.serviceEnabled = false});

  @override
  List<Object?> get props => [
        serviceEnabled,
      ];
}

class RequestLocationServiceState extends AppPermissionState {
  final bool serviceEnabled;

  RequestLocationServiceState({this.serviceEnabled = false});

  @override
  List<Object?> get props => [
        serviceEnabled,
      ];
}

class CheckLocationPermissionEnableState extends AppPermissionState {
  final PermissionStatus? permissionGranted;

  CheckLocationPermissionEnableState({this.permissionGranted});

  @override
  List<Object?> get props => [
        permissionGranted,
      ];
}

class RequestLocationPermissionState extends AppPermissionState {
  final PermissionStatus? permissionGranted;

  RequestLocationPermissionState({this.permissionGranted});

  @override
  List<Object?> get props => [
        permissionGranted,
      ];
}

class GetCurrentLocationState extends AppPermissionState {
  final LocationData? location;
  final String? error;
  final String? message;

  GetCurrentLocationState({this.location, this.error, this.message});

  @override
  List<Object?> get props => [
        location,
        error,
        message,
      ];
}

class UpdateLocationState extends AppPermissionState {
  final LatLng? latLng;
  final String place;
  final bool hasPlace;
  final String message;
  UpdateLocationState({
    this.latLng,
    this.place = '',
    this.hasPlace = false,
    this.message = '',
  });

  @override
  List<Object?> get props => [
        latLng,
        place,
        hasPlace,
        message,
      ];
}
