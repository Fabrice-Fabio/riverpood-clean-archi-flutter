import 'package:travel_app/features/trips/data/datasources/trip_local_datasource.dart';
import 'package:travel_app/features/trips/domain/entitites/trip.dart';
import 'package:travel_app/features/trips/domain/repositories/trip_repository.dart';

import '../models/trip_model.dart';

class TripRepositoryImpl implements TripRepository{
  final TripLocalDataSource localDataSource;

  TripRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTrip(Trip trip) async {
    final tripModel = TripModel.fromEntity(trip);
    localDataSource.addTrip(tripModel);
  }

  @override
  Future<void> deleteTrip(int index) async {
    localDataSource.deleteTrip(index);
  }

  @override
  Future<List<Trip>> getTrips() async {
    final tripModels = localDataSource.getTrips();
    return tripModels.map((model) => model.toEntity()).toList();
  }

}