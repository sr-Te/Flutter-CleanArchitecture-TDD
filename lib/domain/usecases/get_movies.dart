import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failure.dart';
import '../../core/network/api/movies_api.dart';
import '../../core/network/api/movies_endpoint.dart';
import '../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMovies extends UseCase<List<Movie>, Params> {
  final MoviesRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(Params params) async {
    return await repository.getMovies(
      params.endpoint,
      params.language,
      params.genreId,
    );
  }
}

class Params extends Equatable {
  final String language;
  final String endpoint;
  final int genreId;

  Params({
    this.endpoint = MoviesEndpoint.popular,
    this.language = MoviesApi.es,
    this.genreId,
  });

  @override
  List<Object> get props => [this.endpoint, this.language, this.genreId];
}
