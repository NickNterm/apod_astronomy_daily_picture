import 'dart:convert';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/models/astronomy_fact_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/entities/astronomy_fact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockAstronomyFactModel extends Mock implements AstronomyFactModel {}

void main() {
  MockAstronomyFactModel mockAstronomyFactModel = MockAstronomyFactModel();
  AstronomyFactModel tAstronomyFactModel = AstronomyFactModel(
    title: 'title',
    explanation: 'explanation',
    date: DateTime(2021, 1, 1),
    imageUrl: 'url',
    copyRight: 'copyright',
  );

  test('should be a subclass of AstronomyFact', () async {
    // assert
    expect(mockAstronomyFactModel, isA<AstronomyFact>());
  });

  test('should return AstronomyFactModel', () async {
    // arrange
    final Map<String, dynamic> jsonMap = jsonDecode(fixture('fact_json.json'));
    // act
    final result = AstronomyFactModel.fromJson(jsonMap);
    // assert
    expect(result, tAstronomyFactModel);
  });

  test('should return a json map from a astronomy_fact', () async {
    final json = jsonDecode(fixture('fact_json.json'));
    // act
    final result = tAstronomyFactModel.toJson();
    // assert
    expect(result, json);
  });
}
