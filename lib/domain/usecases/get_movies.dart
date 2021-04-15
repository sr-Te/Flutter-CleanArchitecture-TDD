import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';
import '../../data/models/movie_model.dart';
import '../repositories/movies_repository.dart';

class GetMovies extends UseCase<MovieListModel, Params> {
  final MoviesRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, MovieListModel>> call(Params params) async {
    return await repository.getMovies(params.endpoint, params.language);
  }
}

class Params extends Equatable {
  final String language;
  final String endpoint;
  Params({@required this.endpoint, @required this.language});

  @override
  List<Object> get props => [endpoint, language];
}
