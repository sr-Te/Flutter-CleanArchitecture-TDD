import '../../models/genre_model.dart';

abstract class GenresLocalDataSource {
  Future<List<GenreModel>> getLastGenres();
  Future<void> cacheGenres(List<GenreModel> moviesToCache);
}

class GenresLocalDataSourseImpl implements GenresLocalDataSource {
  @override
  Future<void> cacheGenres(List<GenreModel> moviesToCache) {
    // TODO: implement cacheGenres
    throw UnimplementedError();
  }

  @override
  Future<List<GenreModel>> getLastGenres() {
    // TODO: implement getLastGenres
    throw UnimplementedError();
  }
}
