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
  print("-- step 0 --");
  final Box<TripModel> tripBox = Hive.box('trips');
  return TripLocalDataSource(tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  print("-- step 1 --");
  final localDataSource = ref.read(tripLocalDataSourceProvider);
  return TripRepositoryImpl(localDataSource);
});

final getTripsProvider = Provider<GetTrips>((ref) {
  print("-- step 2 --");
  final repository = ref.read(tripRepositoryProvider);
  return GetTrips(repository);
});

final addTripProvider = Provider<AddTrip>((ref) {
  print("-- step 3 --");
  final repository = ref.read(tripRepositoryProvider);
  return AddTrip(repository);
});

final deleteTripProvider = Provider<DeleteTrip>((ref) {
  print("-- step 4 --");
  final repository = ref.read(tripRepositoryProvider);
  return DeleteTrip(repository);
});

// This provider will hold the list of trips.
final tripListProvider = StateProvider<List<Trip>>((ref) => []);

// This provider will manage fetching trips from the repository.
final tripListNotifierProvider = StateNotifierProvider<TripListNotifier, List<Trip>>((ref) {
  print("-- step 5 --");
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
    print("loadTrips :");
    final tripsOrFailure = await _getTrips();
    tripsOrFailure.fold((error) => state = [], (trips) => state = trips);
  }

  Future<void> addNewTrip(Trip trip) async {
    print("addNewTrip :${trip.date}");
    await _addTrip(trip);
  }

  Future<void> removeTrip(int tripId) async {
    print("removeTrip :");
    await _deleteTrip(tripId);
  }
}