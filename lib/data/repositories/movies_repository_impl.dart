import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/api/movies_endpoint.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
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
    int genreId,
  ) async {
    if (endpoint == MoviesEndpoint.withGenre &&
        moviesByCategory[genreId] != null &&
        moviesByCategory[genreId].isNotEmpty) {
      return Right(moviesByCategory[genreId]);
    } else if (moviesByEnpoint[endpoint] != null &&
        moviesByEnpoint[endpoint].isNotEmpty) {
      return Right(moviesByEnpoint[endpoint]);
    } else if (await networkInfo.isConnected) {
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

  void _saveData(String endpoint, int genreId, List<MovieModel> movies) {
    if (endpoint == MoviesEndpoint.withGenre) {
      moviesByCategory[genreId] = movies;
    } else {
      moviesByEnpoint[endpoint] = movies;
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> searchMovies(
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
    return Right(Movie());
  }
}
