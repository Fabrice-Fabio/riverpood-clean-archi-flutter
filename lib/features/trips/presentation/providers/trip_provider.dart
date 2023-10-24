import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_app/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:travel_app/features/trips/domain/usecases/get_trips.dart';

import '../../data/datasources/trip_local_datasource.dart';
import '../../data/models/trip_model.dart';
import '../../domain/entitites/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/add_trip.dart';
import '../../domain/usecases/delete_trip.dart';

final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final Box<TripModel> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  return TripRepositoryImpl(localDataSource);
});

final getTripsProvider = Provider<GetTrips>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return GetTrips(repository);
});

final addTripProvider = Provider<AddTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return AddTrip(repository);
});

final deleteTripProvider = Provider<DeleteTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return DeleteTrip(repository);
});

// This provider will manage fetching trips from the repository.
final tripListNotifierProvider = StateNotifierProvider<TripListNotifier, List<Trip>>((ref) {
  final getTrips = ref.read(getTripsProvider);
  final addTrip = ref.read(addTripProvider);
  final deleteTrip = ref.read(deleteTripProvider);

  return TripListNotifier(getTrips, addTrip, deleteTrip);
});

class TripListNotifier extends StateNotifier<List<Trip>> {
  final GetTrips _getTrips;
  final AddTrip _addTrip;
  final DeleteTrip _deleteTrip;

  TripListNotifier(this._getTrips, this._addTrip, this._deleteTrip) : super([]);

  // Load trips from the repository and update the state.
  Future<void> loadTrips() async {
    final tripsOrFailure = await _getTrips();
    tripsOrFailure.fold((error) => state = [], (trips) => state = trips);
  }

  Future<void> addNewTrip(Trip trip) async {
    await _addTrip(trip);
    //state = [...state, trip];
  }

  Future<void> removeTrip(int tripId) async {
    await _deleteTrip(tripId);
  }
}