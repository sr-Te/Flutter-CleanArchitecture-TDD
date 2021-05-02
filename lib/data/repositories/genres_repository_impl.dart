import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/genres_repository.dart';
import '../datasources/genres/genres_local_data_source.dart';
import '../datasources/genres/genres_remote_data_source.dart';

class GenresRepositoryImpl extends GenresRepository {
  final GenresRemoteDataSource remoteDataSource;
  final GenresLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GenresRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Genre>>> getGenres(String language) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGenres = await remoteDataSource.getGenres(language);
        localDataSource.cacheGenres(remoteGenres);
        return Right(remoteGenres);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localGenres = await localDataSource.getLastGenres();
        return Right(localGenres);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
