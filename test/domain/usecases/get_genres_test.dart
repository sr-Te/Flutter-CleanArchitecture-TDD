import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/genre.dart';
import 'package:my_movie_list/domain/repositories/genres_repository.dart';
import 'package:my_movie_list/domain/usecases/get_genres.dart';

class MockGenresRepository extends Mock implements GenresRepository {}

void main() {
  GetGenres usecase;
  MockGenresRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockGenresRepository();
    usecase = GetGenres(mockMovieRepository);
  });

  final tLanguage = MoviesApi.en;
  final tGenreList = [Genre(id: 1, name: 'test')];

  test(
    'shoul get movie list from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getGenres(any))
          .thenAnswer((_) async => Right(tGenreList));
      // act
      final result = await usecase(GenresParams(language: tLanguage));
      // assert
      expect(result, Right(tGenreList));
      verify(mockMovieRepository.getGenres(tLanguage));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
