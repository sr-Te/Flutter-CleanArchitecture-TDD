import 'package:equatable/equatable.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_movie_list/core/usecases/usecase.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/repositories/movies_repository.dart';

class GetMovieDetail extends UseCase<Movie, MovieDetailParams> {
  final MoviesRepository repository;

  GetMovieDetail(this.repository);

  @override
  Future<Either<Failure, Movie>> call(params) async {
    return await repository.getMovieDetail(params.language, params.movieId);
  }
}

class MovieDetailParams extends Equatable {
  final String language;
  final int movieId;

  MovieDetailParams({this.language, this.movieId});

  @override
  List<Object> get props => [language, movieId];
}
