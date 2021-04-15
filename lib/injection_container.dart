import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'core/network/network_info.dart';
import 'data/datasources/movies_local_data_source.dart';
import 'data/datasources/movies_remote_data_source.dart';
import 'data/repositories/movies_repository_impl.dart';
import 'domain/repositories/movies_repository.dart';
import 'domain/usecases/get_movies_now_playing.dart';
import 'presentation/movies/bloc/movies_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //!     FEATURES - MOVIES
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Bloc
  sl.registerFactory(
    () => MoviesBloc(
      nowPlaying: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetMoviesNowPlaying(sl()));

  // Repository
  sl.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //!     CORE
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //!     EXTERNAL
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // http
  sl.registerLazySingleton(() => http.Client());

  // connection checker
  sl.registerLazySingleton(() => DataConnectionChecker());
}