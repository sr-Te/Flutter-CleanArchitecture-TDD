import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMoviesNowPlaying(String language);
}
