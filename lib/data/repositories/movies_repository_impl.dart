import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/api/movies_endpoint.dart';
import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/actor.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies/movies_local_data_source.dart';
import '../datasources/movies/movies_remote_data_source.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;
  final MoviesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MoviesRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  Map<String, List<Movie>> moviesByEnpoint = {};
  Map<int, List<Movie>> moviesByCategory = {};

  @override
  Future<Either<Failure, List<Movie>>> getMovies(
    String endpoint,
    String language,
    int genreId,
  ) async {
    if (_isInMoviesByCategory(endpoint, genreId))
      return Right(moviesByCategory[genreId]);
    else if (_isInMoviesByEndpoint(endpoint))
      return Right(moviesByEnpoint[endpoint]);
    else if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getMovies(
          endpoint,
          language,
          genreId,
        );
        localDataSource.cacheMovies(endpoint + '$genreId', remoteMovies);
        _saveData(endpoint, genreId, remoteMovies);
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMovies(
          endpoint + '$genreId',
        );
        _saveData(endpoint, genreId, localMovies);
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(
    String language,
    String query,
  ) async {
    if (await networkInfo.isConnected)
      try {
        final remoteMovies = await remoteDataSource.searchMovies(
          language,
          query,
        );
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    else
      return Left(InternetFailure());
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetail(
    String language,
    int movieId,
  ) async {
    if (await networkInfo.isConnected)
      try {
        final remoteMovieDetail = await remoteDataSource.getMovieDetail(
          language,
          movieId,
        );
        return Right(remoteMovieDetail);
      } on ServerException {
        return Left(ServerFailure());
      }
    else
      return Left(InternetFailure());
  }

  @override
  Future<Either<Failure, List<Actor>>> getMovieCast(
    String language,
    int movieId,
  ) async {
    if (await networkInfo.isConnected)
      try {
        final remoteMovieDetail = await remoteDataSource.getMovieCast(
          language,
          movieId,
        );
        return Right(remoteMovieDetail);
      } on ServerException {
        return Left(ServerFailure());
      }
    else
      return Left(InternetFailure());
  }

  void _saveData(String endpoint, int genreId, List<Movie> movies) {
    if (endpoint == MoviesEndpoint.withGenre) {
      moviesByCategory[genreId] = movies;
    } else {
      moviesByEnpoint[endpoint] = movies;
    }
  }

  bool _isInMoviesByCategory(String endpoint, int genreId) =>
      endpoint == MoviesEndpoint.withGenre &&
      moviesByCategory[genreId] != null &&
      moviesByCategory[genreId].isNotEmpty;

  bool _isInMoviesByEndpoint(String endpoint) =>
      moviesByEnpoint[endpoint] != null && moviesByEnpoint[endpoint].isNotEmpty;
}
