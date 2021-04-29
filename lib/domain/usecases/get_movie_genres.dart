import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../repositories/movies_repository.dart';

class GetMovieGenres extends UseCase<List<Genre>, Params> {
  final MoviesRepository repository;

  GetMovieGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(params) async {
    return await repository.getMovieGenres(params.language);
  }
}

class Params extends Equatable {
  final String language;
  Params({@required this.language});

  @override
  List<Object> get props => [language];
}
