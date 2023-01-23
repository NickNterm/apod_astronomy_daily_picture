import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/astronomy_fact.dart';

abstract class AstronomyFactRepository {
  Future<Either<Failure, AstronomyFact>> getAstronomyFact(DateTime date);
}
