import 'dart:convert';

import 'package:astronomy_picture_of_the_day/core/error/exceptions.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/models/astronomy_fact_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/remote_data/remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  http.Client mockHttpClient = MockHttpClient();

  AstronomyFactRemoteDataSourceImpl remoteDataSource = AstronomyFactRemoteDataSourceImpl(client: mockHttpClient);

  DateTime tDate = DateTime.parse('2021-09-01');
  AstronomyFactModel tAstronomyFactModel = AstronomyFactModel.fromJson(jsonDecode(fixture('fact_json.json')));

  test('should return astronomy fact model from the api call', () async {
    //arrange
    when(() => mockHttpClient.get(
        Uri.parse(
          'https://api.nasa.gov/planetary/apod?api_key=Lqsn2BRKCjfAwvQbJxpkdzPSXYx1DZukjFlvl5L7&date=${tDate.year}-${tDate.month}-${tDate.day}',
        ),
        headers: any(named: 'headers'))).thenAnswer(
      (_) async => http.Response(fixture('fact_json.json'), 200),
    );
    //act
    final result = await remoteDataSource.getAstronomyFact(tDate);
    //assert
    expect(result, tAstronomyFactModel);
  });

  test('should throw exception when the api call is unsuccessful', () async {
    //arrange
    when(() => mockHttpClient.get(
        Uri.parse(
          'https://api.nasa.gov/planetary/apod?api_key=Lqsn2BRKCjfAwvQbJxpkdzPSXYx1DZukjFlvl5L7&date=${tDate.year}-${tDate.month}-${tDate.day}',
        ),
        headers: any(named: 'headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
    //act
    final call = remoteDataSource.getAstronomyFact;
    //assert
    expect(() => call(tDate), throwsA(isA<ServerException>()));
  });
}
