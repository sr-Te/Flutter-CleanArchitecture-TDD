import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../data/models/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesNowPlaying extends UseCase<List<Movie>, Params> {
  final MovieRepository repository;

  GetMoviesNowPlaying(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(Params params) async {
    return await repository.getMoviesNowPlaying(params.language);
  }
}

class Params extends Equatable {
  final String language;
  Params({@required this.language});

  @override
  List<Object> get props => [language];
}
