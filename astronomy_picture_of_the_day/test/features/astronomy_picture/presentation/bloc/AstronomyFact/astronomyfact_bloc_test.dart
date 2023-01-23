import 'dart:convert';

import 'package:astronomy_picture_of_the_day/core/error/failures.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/models/astronomy_fact_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/entities/astronomy_fact.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/usecases/get_astronomy_fact.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/presentation/bloc/AstronomyFact/astronomyfact_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockGetAstronomyFactBloc extends Mock implements GetAstronomyFact {}

void main() {
  GetAstronomyFact mockGetAstronomyFact = MockGetAstronomyFactBloc();
  AstronomyfactBloc bloc = AstronomyfactBloc(getAstronomyFact: mockGetAstronomyFact);
  group('AstronomyfactBloc', () {
    AstronomyFact tAstronomyFact = AstronomyFactModel.fromJson(jsonDecode(fixture('fact_json.json')));
    DateTime tDate = DateTime(2020, 5, 10);
    test('should return AstronomyfactInitial when the bloc is initialized', () {
      //assert
      expect(bloc.state, equals(AstronomyfactInitial()));
    });

    test('should get the data from the usecase', () async {
      // arrange
      when(() => mockGetAstronomyFact(date: tDate)).thenAnswer((_) async => Right(tAstronomyFact));
      // act
      bloc.add(GetAstronomyFactEvent(tDate));
      await untilCalled(() => mockGetAstronomyFact(date: tDate));
      // assert
      verify(() => mockGetAstronomyFact(date: tDate));
    });

    test('should emit loading and loaded when the data is called', () async* {
      //arrange
      when(() => mockGetAstronomyFact(date: tDate)).thenAnswer((_) async => Right(tAstronomyFact));
      //act
      final expected = [
        AstronomyfactInitial(),
        AstronomyfactLoading(),
        AstronomyfactLoaded(tAstronomyFact),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //assert
      bloc.add(GetAstronomyFactEvent(tDate));
    });

    test('should emit error when the data cant get taken from the api', () async* {
      when(() => mockGetAstronomyFact(date: tDate)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final expected = [
        AstronomyfactInitial(),
        AstronomyfactLoading(),
        AstronomyfactError(errorLoadingTheDataFromTheApi),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //assert
      bloc.add(GetAstronomyFactEvent(tDate));
    });

    test('should emit error when the data cant get taken from the cache', () async* {
      when(() => mockGetAstronomyFact(date: tDate)).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final expected = [
        AstronomyfactInitial(),
        AstronomyfactLoading(),
        AstronomyfactError(errorLoadingTheDataFromTheCache),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //assert
      bloc.add(GetAstronomyFactEvent(tDate));
    });
  });
}
