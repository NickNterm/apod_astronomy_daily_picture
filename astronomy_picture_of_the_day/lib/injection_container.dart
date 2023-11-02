import 'package:astronomy_picture_of_the_day/core/network/network_info.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/data/local_data/local_data_source.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/astronomy_picture/data/remote_data/remote_data_source.dart';
import 'features/astronomy_picture/data/repositories/astronomy_fact_repository_impl.dart';
import 'features/astronomy_picture/domain/repositories/astronomy_fact_repository.dart';
import 'features/astronomy_picture/domain/usecases/get_astronomy_fact.dart';
import 'features/astronomy_picture/presentation/bloc/AstronomyFact/astronomyfact_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features - AstronomyFact
  // Bloc
  sl.registerLazySingleton(
    () => AstronomyfactBloc(
      getAstronomyFact: sl(),
    ),
  );
  // Repository
  sl.registerLazySingleton<AstronomyFactRepository>(
    () => AstronomyFactRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      localDataSource: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<AstronomyFactRemoteDataSource>(
    () => AstronomyFactRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<AstronomyFactLocalDataSource>(
    () => AstronomyFactLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(() => GetAstronomyFact(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}
