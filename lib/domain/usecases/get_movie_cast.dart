import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';
import '../entities/actor.dart';
import '../repositories/movies_repository.dart';

class GetMovieCast extends UseCase<List<Actor>, CastParams> {
  final MoviesRepository repository;

  GetMovieCast(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> call(params) async {
    return await repository.getMovieCast(params.language, params.movieId);
  }
}

class CastParams extends Equatable {
  final String language;
  final int movieId;

  CastParams({this.language, this.movieId});

  @override
  List<Object> get props => [language, movieId];
}
