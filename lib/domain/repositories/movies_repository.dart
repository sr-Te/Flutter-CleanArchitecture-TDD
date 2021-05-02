import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../data/models/movie_model.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<MovieModel>>> getMovies(
    String endpoint,
    String language,
  );
}
