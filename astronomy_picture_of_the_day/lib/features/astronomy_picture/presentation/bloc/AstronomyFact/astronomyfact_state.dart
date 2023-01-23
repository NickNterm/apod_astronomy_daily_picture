part of 'astronomyfact_bloc.dart';

const errorLoadingTheDataFromTheApi = 'Problem loading the data from the API';
const errorLoadingTheDataFromTheCache = 'Problem loading the data from the Memory Cache';

@immutable
abstract class AstronomyfactState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AstronomyfactInitial extends AstronomyfactState {}

class AstronomyfactLoading extends AstronomyfactState {}

class AstronomyfactLoaded extends AstronomyfactState {
  final AstronomyFact astronomyFact;
  AstronomyfactLoaded(this.astronomyFact);
}

class AstronomyfactError extends AstronomyfactState {
  final String message;
  AstronomyfactError(this.message);
}
