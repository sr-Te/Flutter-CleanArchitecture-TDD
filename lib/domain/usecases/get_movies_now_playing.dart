import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/data/models/movie_model.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/movies_repository.dart';

class GetMoviesNowPlaying extends UseCase<MovieListModel, Params> {
  final MoviesRepository repository;

  GetMoviesNowPlaying(this.repository);

  @override
  Future<Either<Failure, MovieListModel>> call(Params params) async {
    return await repository.getMoviesNowPlaying(params.language);
  }
}

class Params extends Equatable {
  final String language;
  Params({@required this.language});

  @override
  List<Object> get props => [language];
}
