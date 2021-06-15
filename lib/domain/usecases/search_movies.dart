import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failure.dart';
import '../../core/network/api/movies_api.dart';
import '../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class SearchMovies extends UseCase<List<Movie>, SearchMoviesParams> {
  final MoviesRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) async {
    var res = await repository.searchMovies(params.language, params.query);
    return res;
  }
}

class SearchMoviesParams extends Equatable {
  final String language;
  final String query;

  SearchMoviesParams({this.language = MoviesApi.es, this.query});

  @override
  List<Object> get props => [this.language, this.query];
}
