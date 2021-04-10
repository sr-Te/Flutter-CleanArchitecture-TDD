import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movie_model.dart';

class MoviesRepositoryImpl implements MovieRepository {
  final MoviesRemoteDataSource remoteDataSource;
  final MoviesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MoviesRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, MovieListModel>> getMoviesNowPlaying(
    String language,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies =
            await remoteDataSource.getMoviesNowPlaying(language);
        localDataSource.cacheMoviesNowPlaying(remoteMovies);
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMoviesNowPlaying();
        return Right(localMovies);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
