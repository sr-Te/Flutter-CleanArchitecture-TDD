import '../../models/genre_model.dart';

abstract class GenresRemoteDataSource {
  Future<List<GenreModel>> getGenres(String language);
}
