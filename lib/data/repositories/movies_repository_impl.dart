import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies/movies_local_data_source.dart';
import '../datasources/movies/movies_remote_data_source.dart';
import '../models/movie_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;
  final MoviesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  Map<String, List<MovieModel>> moviesByCategory = {};

  MoviesRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieModel>>> getMovies(
    String endpoint,
    String language,
  ) async {
    if (moviesByCategory[endpoint] != null &&
        moviesByCategory[endpoint].isNotEmpty) {
      return Right(moviesByCategory[endpoint]);
    } else if (await networkInfo.isConnected) {
      try {
        final remoteMovies =
            await remoteDataSource.getMovies(endpoint, language);
        localDataSource.cacheMovies(endpoint, remoteMovies);
        moviesByCategory[endpoint] = remoteMovies;
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMovies(endpoint);
        moviesByCategory[endpoint] = localMovies;
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
