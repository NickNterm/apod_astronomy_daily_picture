import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/astronomy_fact.dart';
import '../repositories/astronomy_fact_repository.dart';

class GetAstronomyFact {
  final AstronomyFactRepository repository;

  GetAstronomyFact(this.repository);

  Future<Either<Failure, AstronomyFact>> call({
    required DateTime date,
  }) async {
    return await repository.getAstronomyFact(date);
  }
}
