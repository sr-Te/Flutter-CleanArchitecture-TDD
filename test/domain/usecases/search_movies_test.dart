import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/repositories/movies_repository.dart';
import 'package:my_movie_list/domain/usecases/search_movies.dart';

class MockMovieRepository extends Mock implements MoviesRepository {}

void main() {
  SearchMovies usecase;
  MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovies(mockMovieRepository);
  });

  final List<Movie> tMovieList = [];
  final tLanguage = MoviesApi.es;
  final tQuery = 'k';

  test(
    'shoul get movie list from the repository',
    () async {
      // arrange
      when(mockMovieRepository.searchMovies(any, any))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      final result = await usecase(
        SearchMoviesParams(language: tLanguage, query: tQuery),
      );
      // assert
      expect(result, Right(tMovieList));
      verify(mockMovieRepository.searchMovies(tLanguage, tQuery));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
