import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../entities/genre.dart';

abstract class GenresRepository {
  Future<Either<Failure, List<Genre>>> getGenres(String language);
}
