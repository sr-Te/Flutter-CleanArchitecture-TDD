import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../repositories/genres_repository.dart';

class GetGenres extends UseCase<List<Genre>, GenresParams> {
  final GenresRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(params) async {
    return await repository.getGenres(params.language);
  }
}

class GenresParams extends Equatable {
  final String language;

  GenresParams({this.language});

  @override
  List<Object> get props => [language];
}
