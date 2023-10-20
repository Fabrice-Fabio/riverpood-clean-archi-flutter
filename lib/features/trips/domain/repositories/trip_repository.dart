import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';

import '../entitites/trip.dart';

abstract class TripRepository{
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<void> addTrip(Trip trip);
  Future<void> deleteTrip(int index);
}