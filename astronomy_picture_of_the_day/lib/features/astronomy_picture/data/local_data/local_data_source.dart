import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/astronomy_fact_model.dart';

abstract class AstronomyFactLocalDataSource {
  Future<AstronomyFactModel> getLastAstronomyFact();
  void cacheNewAstronomyFact(AstronomyFactModel astronomyFact);
}

const cachedAstronomyFact = 'CACHED_ASTRONOMY_FACT';

class AstronomyFactLocalDataSourceImpl extends AstronomyFactLocalDataSource {
  final SharedPreferences sharedPreferences;
  AstronomyFactLocalDataSourceImpl({
    required this.sharedPreferences,
  });
  @override
  void cacheNewAstronomyFact(AstronomyFactModel astronomyFact) {
    final jsonString = jsonEncode(astronomyFact.toJson());
    sharedPreferences.setString(cachedAstronomyFact, jsonString);
  }

  @override
  Future<AstronomyFactModel> getLastAstronomyFact() {
    String? astronomyFactString = sharedPreferences.getString(cachedAstronomyFact);
    if (astronomyFactString != null) {
      return Future.value(AstronomyFactModel.fromJson(jsonDecode(astronomyFactString)));
    } else {
      throw CacheException();
    }
  }
}
