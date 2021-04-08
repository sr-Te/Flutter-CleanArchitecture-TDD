import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/core/errors/exception.dart';

import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieModel>>> getMoviesNowPlaying(
    String language,
  ) async {
    networkInfo.isConnected;
    try {
      final remoteMovies = await remoteDataSource.getMoviesNowPlaying(language);
      return Right(remoteMovies);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
