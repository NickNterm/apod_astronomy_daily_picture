part of 'astronomyfact_bloc.dart';

@immutable
abstract class AstronomyfactEvent {}

class GetAstronomyFactEvent extends AstronomyfactEvent {
  final DateTime date;
  GetAstronomyFactEvent(this.date);
}
