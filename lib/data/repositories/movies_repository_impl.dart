import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/core/network/api/movies_endpoint.dart';

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

  Map<String, List<MovieModel>> moviesByEnpoint = {};
  Map<int, List<MovieModel>> moviesByCategory = {};

  MoviesRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieModel>>> getMovies(
    String endpoint,
    String language,
    int genre,
  ) async {
    if (endpoint == MoviesEndpoint.withGenre &&
        moviesByCategory[genre] != null &&
        moviesByCategory[genre].isNotEmpty) {
      return Right(moviesByCategory[genre]);
    } else if (moviesByEnpoint[endpoint] != null &&
        moviesByEnpoint[endpoint].isNotEmpty) {
      return Right(moviesByEnpoint[endpoint]);
    } else if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getMovies(
          endpoint,
          language,
          genre,
        );
        localDataSource.cacheMovies(endpoint + '$genre', remoteMovies);
        _saveData(endpoint, genre, remoteMovies);
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMovies(
          endpoint + '$genre',
        );
        _saveData(endpoint, genre, localMovies);
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  void _saveData(String endpoint, int genre, List<MovieModel> movies) {
    if (endpoint == MoviesEndpoint.withGenre) {
      moviesByCategory[genre] = movies;
    } else {
      moviesByEnpoint[endpoint] = movies;
    }
  }
}
