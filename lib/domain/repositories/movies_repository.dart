import 'package:dartz/dartz.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

import '../../core/errors/failure.dart';
import '../../data/models/movie_model.dart';

abstract class MoviesRepository {
  Future<Either<Failure, MovieListModel>> getMovies(
    String endpoint,
    String language,
  );

  Future<Either<Failure, List<Genre>>> getMovieGenres(String language);
}
