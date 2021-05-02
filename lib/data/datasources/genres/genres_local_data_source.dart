import '../../../domain/entities/genre.dart';

abstract class GenresLocalDataSource {
  Future<List<Genre>> getLastGenres();
  Future<void> cacheGenres(List<Genre> moviesToCache);
}

class GenresLocalDataSourseImpl implements GenresLocalDataSource {
  @override
  Future<void> cacheGenres(List<Genre> moviesToCache) {
    // TODO: implement cacheGenres
    throw UnimplementedError();
  }

  @override
  Future<List<Genre>> getLastGenres() {
    // TODO: implement getLastGenres
    throw UnimplementedError();
  }
}
