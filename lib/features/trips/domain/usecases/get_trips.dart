import '../entitites/trip.dart';
import '../repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips(this.repository);

  Future<List<Trip>> call(){
    return repository.getTrips();
  }
}