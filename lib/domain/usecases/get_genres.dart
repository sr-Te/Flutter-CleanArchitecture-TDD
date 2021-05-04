import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failure.dart';
import '../../core/network/api/movies_api.dart';
import '../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../repositories/genres_repository.dart';

class GetGenres extends UseCase<List<Genre>, Params> {
  final GenresRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(params) async {
    return await repository.getGenres(params.language);
  }
}

class Params extends Equatable {
  final String language;

  Params({this.language = MoviesApi.es});

  @override
  List<Object> get props => [language];
}
