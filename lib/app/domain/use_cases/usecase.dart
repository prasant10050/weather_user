import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_user/app/domain/entities/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  List<Object> get props => [];
}
