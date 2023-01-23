import 'dart:convert';

import 'package:astronomy_picture_of_the_day/core/error/exceptions.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/local_data/local_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/models/astronomy_fact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences mockSharedPreferences = MockSharedPreferences();
  AstronomyFactLocalDataSource localDataSource =
      AstronomyFactLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);

  final tAstronomyFact = AstronomyFactModel.fromJson(jsonDecode(fixture('fact_json.json')));

  test('should return the cached fact if there is one', () async {
    //arrange
    when(() => mockSharedPreferences.getString(any())).thenReturn(fixture('fact_json.json'));
    //act
    final result = await localDataSource.getLastAstronomyFact();
    //assert
    verify(() => mockSharedPreferences.getString(cachedAstronomyFact));
    expect(result, equals(tAstronomyFact));
  });

  test('should return CacheFailure if there is no cached fact', () async {
    //arrange
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    //act
    final call = localDataSource.getLastAstronomyFact;
    //assert
    expect(() => call(), throwsA(isA<CacheException>()));
  });

  test('should cache the fact', () async {
    //arrange
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
    //act
    localDataSource.cacheNewAstronomyFact(tAstronomyFact);
    //assert
    final expectedJsonString = jsonEncode(tAstronomyFact.toJson());
    verify(() => mockSharedPreferences.setString(cachedAstronomyFact, expectedJsonString));
  });
}
