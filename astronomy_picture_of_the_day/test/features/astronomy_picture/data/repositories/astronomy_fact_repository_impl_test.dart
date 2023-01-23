import 'dart:convert';

import 'package:astronomy_picture_of_the_day/core/error/exceptions.dart';
import 'package:astronomy_picture_of_the_day/core/error/failures.dart';
import 'package:astronomy_picture_of_the_day/core/network/network_info.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/local_data/local_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/models/astronomy_fact_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/remote_data/remote_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/repositories/astronomy_fact_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class AstronomyFactRemoteDataSourceMock extends Mock implements AstronomyFactRemoteDataSource {}

class AstronomyFactLocalDataSourceMock extends Mock implements AstronomyFactLocalDataSource {}

class NetworkInfoMock extends Mock implements NetworkInfo {}

void main() {
  AstronomyFactRemoteDataSource remoteDataSource = AstronomyFactRemoteDataSourceMock();
  AstronomyFactLocalDataSource localDataSource = AstronomyFactLocalDataSourceMock();
  NetworkInfo networkInfo = NetworkInfoMock();
  AstronomyFactRepositoryImpl astronomyFactRepositoryImpl = AstronomyFactRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  group('GetAstronomyFact', () {
    AstronomyFactModel tAstronomyFactModel = AstronomyFactModel.fromJson(jsonDecode(fixture('fact_json.json')));
    DateTime tDate = DateTime.parse('2021-09-01');
    test('should check if the connection is online', () async {
      //arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getAstronomyFact(any())).thenAnswer((_) async => tAstronomyFactModel);
      //act
      astronomyFactRepositoryImpl.getAstronomyFact(tDate);
      //assert
      verify(() => networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test('should return the remote data when the call to remote data source is successful', () async {
        //arrange
        when(() => remoteDataSource.getAstronomyFact(any())).thenAnswer((_) async => tAstronomyFactModel);
        //act
        final result = await astronomyFactRepositoryImpl.getAstronomyFact(tDate);
        //assert
        verify(() => remoteDataSource.getAstronomyFact(tDate));
        expect(result, equals(Right(tAstronomyFactModel)));
      });

      test('should cache the fact that is loaded', () async {
        //arrange
        when(() => remoteDataSource.getAstronomyFact(any())).thenAnswer((_) async => tAstronomyFactModel);
        //act
        await astronomyFactRepositoryImpl.getAstronomyFact(tDate);
        //assert
        verify(() => remoteDataSource.getAstronomyFact(tDate));
        verify(() => localDataSource.cacheNewAstronomyFact(tAstronomyFactModel));
      });
      test('should throw exception if the api cant fetch data', () async {
        //arrange
        when(() => remoteDataSource.getAstronomyFact(any())).thenThrow(ServerException());
        //act
        final response = await astronomyFactRepositoryImpl.getAstronomyFact(tDate);
        //assert
        verify(() => remoteDataSource.getAstronomyFact(tDate));
        expect(response, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return the local data', () async {
        //arrange
        when(() => localDataSource.getLastAstronomyFact()).thenAnswer((_) async => tAstronomyFactModel);
        //act
        final result = await astronomyFactRepositoryImpl.getAstronomyFact(tDate);
        //assert
        verify(() => localDataSource.getLastAstronomyFact());
        expect(result, equals(Right(tAstronomyFactModel)));
      });
      test('should throw an error if there is not a fact saved in the device', () async {
        //arrange
        when(() => localDataSource.getLastAstronomyFact()).thenThrow(CacheException());
        //act
        final result = await astronomyFactRepositoryImpl.getAstronomyFact(tDate);
        //assert
        verify(() => localDataSource.getLastAstronomyFact());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
