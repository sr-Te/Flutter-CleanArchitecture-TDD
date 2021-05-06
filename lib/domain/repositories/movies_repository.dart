import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
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
}
