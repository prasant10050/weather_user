import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather_user/app/data/repositories/location/geocode_repo.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';

part 'app_permission_event.dart';
part 'app_permission_state.dart';

class AppPermissionBloc extends Bloc<AppPermissionEvent, AppPermissionState> {
  AppPermissionBloc() : super(AppPermissionInitial());
  final Location location = Location();

  @override
  Stream<AppPermissionState> mapEventToState(
    AppPermissionEvent event,
  ) async* {
    if (event is CheckLocationServiceEnable) {
      final bool? serviceEnabledResult = await location.serviceEnabled();
      if (serviceEnabledResult != null) {
        if (serviceEnabledResult) {
          add(CheckLocationPermissionEnable());
        } else {
          add(RequestLocationService(serviceEnabled: serviceEnabledResult));
        }
      }
    }
    if (event is RequestLocationService) {
      if (event.serviceEnabled == null || !event.serviceEnabled!) {
        final serviceRequestedResult = await location.requestService();
        if (serviceRequestedResult) {
          add(CheckLocationPermissionEnable());
        } else {
          await AppSettings.openLocationSettings().whenComplete(() {
            add(CheckLocationServiceEnable());
          });
        }
      }
    }
    if (event is CheckLocationPermissionEnable) {
      final permissionGrantedResult = await location.hasPermission();
      if (permissionGrantedResult == PermissionStatus.granted ||
          permissionGrantedResult == PermissionStatus.grantedLimited) {
        add(GetCurrentLocation());
      } else if (permissionGrantedResult == PermissionStatus.denied) {
        add(RequestLocationPermission(
            permissionGranted: permissionGrantedResult));
      } else if (permissionGrantedResult == PermissionStatus.deniedForever) {
        yield CheckLocationPermissionEnableState(
            permissionGranted: permissionGrantedResult);
      }
    }
    if (event is RequestLocationPermission) {
      if (event.permissionGranted != PermissionStatus.granted) {
        final permissionRequestedResult = await location.requestPermission();
        if (permissionRequestedResult == PermissionStatus.granted ||
            permissionRequestedResult == PermissionStatus.grantedLimited) {
          add(GetCurrentLocation());
        } else if (permissionRequestedResult == PermissionStatus.denied) {
          add(RequestLocationPermission(
              permissionGranted: permissionRequestedResult));
        } else if (permissionRequestedResult ==
            PermissionStatus.deniedForever) {
          yield RequestLocationPermissionState(
              permissionGranted: permissionRequestedResult);
        }
      }
    }
    if (event is GetCurrentLocation) {
      try {
        final _locationResult = await location.getLocation();
        yield GetCurrentLocationState(error: null, location: _locationResult);
        add(
          UpdateLocationEvent(
            latLng: LatLng(
                latitude: _locationResult.latitude!,
                longitude: _locationResult.longitude!),
          ),
        );
      } on PlatformException catch (err) {
        yield GetCurrentLocationState(
          error: err.code,
          location: null,
          message: err.message ?? err.details,
        );
      }
    }
    if (event is UpdateLocationEvent) {
      var response = await AppGeoCoding.reverseGeocodeLatLng(event.latLng!);
      await Future.delayed(Duration(milliseconds: 500));
      yield* response.fold((l) async* {
        yield UpdateLocationState(
            latLng: event.latLng!,
            place: '',
            hasPlace: false,
            message: 'Not detect current location');
      }, (r) async* {
        yield UpdateLocationState(
          latLng: event.latLng!,
          place: r.locality!,
          hasPlace: true,
        );
      });
    }
  }
}
