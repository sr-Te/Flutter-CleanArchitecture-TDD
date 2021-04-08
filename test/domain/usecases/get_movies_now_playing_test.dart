import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/repositories/movie_repository.dart';
import 'package:my_movie_list/domain/usecases/get_movies_now_playing.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  GetMoviesNowPlaying usecase;
  MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMoviesNowPlaying(mockMovieRepository);
  });

  final tLanguage = 'en-US';
  final tMovieList = [MovieModel(title: 'test')];

  test(
    'shoul get movie list from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMoviesNowPlaying(any))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      final result = await usecase(Params(language: tLanguage));
      // assert
      expect(result, Right(tMovieList));
      verify(mockMovieRepository.getMoviesNowPlaying(tLanguage));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
