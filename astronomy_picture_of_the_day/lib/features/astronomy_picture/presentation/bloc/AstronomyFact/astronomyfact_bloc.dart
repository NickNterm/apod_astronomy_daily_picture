import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/astronomy_fact.dart';
import '../../../domain/usecases/get_astronomy_fact.dart';
part 'astronomyfact_event.dart';
part 'astronomyfact_state.dart';

class AstronomyfactBloc extends Bloc<AstronomyfactEvent, AstronomyfactState> {
  final GetAstronomyFact getAstronomyFact;
  AstronomyfactBloc({required this.getAstronomyFact}) : super(AstronomyfactInitial()) {
    on<AstronomyfactEvent>((event, emit) async {
      if (event is GetAstronomyFactEvent) {
        emit(AstronomyfactLoading());
        final response = await getAstronomyFact(date: event.date);
        emit(
          response.fold(
            (failure) => AstronomyfactError(
              failure is ServerFailure ? errorLoadingTheDataFromTheApi : errorLoadingTheDataFromTheCache,
            ),
            (fact) => AstronomyfactLoaded(fact),
          ),
        );
      }
    });
  }
}
