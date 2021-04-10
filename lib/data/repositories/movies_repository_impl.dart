import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movie_model.dart';

class MoviesRepositoryImpl implements MovieRepository {
  final MoviesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MoviesRepositoryImpl({
    @required this.remoteDataSource,
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
        return Right(remoteMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: store cache :c
      return Left(ServerFailure());
    }
  }
}
