import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/domain/entities/actor.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
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
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getMovies(
          endpoint,
          language,
          genreId,
        );
        localDataSource.cacheMovies(endpoint + '$genreId', remoteMovies);
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMovies(
          endpoint + '$genreId',
        );
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
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
}
