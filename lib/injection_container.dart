import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'core/network/network_info.dart';
import 'data/datasources/genres/genres_local_data_source.dart';
import 'data/datasources/genres/genres_remote_data_source.dart';
import 'data/datasources/movies/movies_local_data_source.dart';
import 'data/datasources/movies/movies_remote_data_source.dart';
import 'data/repositories/genres_repository_impl.dart';
import 'data/repositories/movies_repository_impl.dart';
import 'domain/repositories/genres_repository.dart';
import 'domain/repositories/movies_repository.dart';
import 'domain/usecases/get_genres.dart';
import 'domain/usecases/get_movie_cast.dart';
import 'domain/usecases/get_movie_detail.dart';
import 'domain/usecases/get_movies.dart';
import 'domain/usecases/search_movies.dart';
import 'presentation/custom_drawer/business_logic/drawer_nav_cubit/drawer_nav_cubit.dart';
import 'presentation/genres/business_logic/genres_cubit.dart';
import 'presentation/movies/business_logic/appbar_search_mode_cubit.dart';
import 'presentation/movies/business_logic/movie_cast_cubit/movie_cast_cubit.dart';
import 'presentation/movies/business_logic/movies_bloc/movies_bloc.dart';
import 'presentation/movies/business_logic/movies_search_cubit/movies_search_cubit.dart';
import 'presentation/movies/business_logic/movie_details_cubit/movie_details_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //!     MOVIES
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Business Logic
  sl.registerFactory(() => DrawerNavCubit());
  sl.registerFactory(() => MoviesBloc(getMovies: sl()));
  sl.registerFactory(() => AppbarSearhModeCubit());
  sl.registerFactory(() => MoviesSearchCubit(searchMovies: sl()));
  sl.registerFactory(() => MovieDetailsCubit(getMovieDetail: sl()));
  sl.registerFactory(() => MovieCastCubit(getMovieCast: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => GetMovieCast(sl()));

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
  //!     Genres
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Business Logic
  sl.registerFactory(() => GenresCubit(getGenres: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetGenres(sl()));

  // Repository
  sl.registerLazySingleton<GenresRepository>(
    () => GenresRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<GenresLocalDataSource>(
    () => GenresLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<GenresRemoteDataSource>(
    () => GenresRemoteDataSourceImpl(client: sl()),
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
