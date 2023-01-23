import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/entities/astronomy_fact.dart';
import 'package:astronomy_picture_of_the_day/core/error/failures.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/repositories/astronomy_fact_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../local_data/local_data_source.dart';
import '../remote_data/remote_data_source.dart';

class AstronomyFactRepositoryImpl extends AstronomyFactRepository {
  final AstronomyFactRemoteDataSource remoteDataSource;
  final AstronomyFactLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AstronomyFactRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AstronomyFact>> getAstronomyFact(DateTime date) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAstronomyFact = await remoteDataSource.getAstronomyFact(date);
        localDataSource.cacheNewAstronomyFact(remoteAstronomyFact);
        return Right(remoteAstronomyFact);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastAstronomyFact());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
