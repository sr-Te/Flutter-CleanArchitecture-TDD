import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/globals/movies_api.dart';
import 'package:my_movie_list/domain/entities/genre.dart';
import 'package:my_movie_list/domain/repositories/movies_repository.dart';
import 'package:my_movie_list/domain/usecases/get_movie_genres.dart';

class MockMovieRepository extends Mock implements MoviesRepository {}

void main() {
  GetMovieGenres usecase;
  MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieGenres(mockMovieRepository);
  });

  final tLanguage = MoviesApi.en;
  final tGenreList = [Genre(id: 1, name: 'test')];

  test(
    'shoul get movie list from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMovieGenres(any))
          .thenAnswer((_) async => Right(tGenreList));
      // act
      final result = await usecase(Params(language: tLanguage));
      // assert
      expect(result, Right(tGenreList));
      verify(mockMovieRepository.getMovieGenres(tLanguage));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
