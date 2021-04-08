import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../data/models/movie_model.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieModel>>> getMoviesNowPlaying(
      String language);
}
