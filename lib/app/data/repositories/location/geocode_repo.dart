import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_user/app/domain/entities/error/base_error.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/domain/entities/location/location_results.dart';

class AppGeoCoding {
  static Future<Either<BaseErrorModel, LocationResults>> reverseGeocodeLatLng(
    LatLng latLng,
  ) async {
    try {
      var locationResults = LocationResults();
      placemarkFromCoordinates(latLng.latitude, latLng.longitude)
          .then((results) {
        if (results.isNotEmpty) {
          final result = results[0];
          locationResults
            ..name = result.name
            ..locality = result.locality
            ..formattedAddress = result.thoroughfare
            ..streetNumber = result.street
            ..postalCode = result.postalCode
            ..country = result.country
            ..administrativeAreaLevel1 = result.administrativeArea
            ..administrativeAreaLevel2 = result.subAdministrativeArea
            ..city = result.locality
            ..subLocalityLevel1 = result.subLocality
            ..latitude = latLng.latitude
            ..longitude = latLng.longitude
            ..geometry = result.toJson();
        }
      });
      return Right(locationResults);
    } catch (e) {
      return Left(BaseErrorModel(responseCode: 1, message: e.toString()));
    }
  }
}
