import '../../../domain/entities/genre.dart';

abstract class GenresRemoteDataSource {
  Future<List<Genre>> getGenres(String language);
}
