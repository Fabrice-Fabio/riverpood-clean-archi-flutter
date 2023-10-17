import 'package:hive_flutter/hive_flutter.dart';

import '../models/trip_model.dart';

class TripLocalDataSource {
  final Box<TripModel> tripBox;

  TripLocalDataSource(this.tripBox);

  List<TripModel> getTrips(){
    return tripBox.values.toList();
  }

  void addTrip(TripModel trip) {
    tripBox.put(trip.id, trip);
  }

  void deleteTrip(int id) {
    tripBox.delete(id);
  }

}