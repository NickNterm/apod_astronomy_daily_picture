import 'dart:convert';

import 'package:astronomy_picture_of_the_day/core/error/exceptions.dart';

import '../models/astronomy_fact_model.dart';
import 'package:http/http.dart' as http;

abstract class AstronomyFactRemoteDataSource {
  Future<AstronomyFactModel> getAstronomyFact(DateTime date);
}

class AstronomyFactRemoteDataSourceImpl extends AstronomyFactRemoteDataSource {
  final http.Client client;

  AstronomyFactRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<AstronomyFactModel> getAstronomyFact(DateTime date) async {
    var uri = Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=Lqsn2BRKCjfAwvQbJxpkdzPSXYx1DZukjFlvl5L7&date=${date.year}-${date.month}-${date.day}',
    );
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return AstronomyFactModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
