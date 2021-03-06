import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../entities/actor.dart';
import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getMovies(
    String endpoint,
    String language,
    int genreId,
  );

  Future<Either<Failure, List<Movie>>> searchMovies(
    String language,
    String query,
  );

  Future<Either<Failure, Movie>> getMovieDetail(
    String language,
    int movieId,
  );

  Future<Either<Failure, List<Actor>>> getMovieCast(
    String language,
    int movieId,
  );
}
