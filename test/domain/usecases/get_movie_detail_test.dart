import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/repositories/movies_repository.dart';
import 'package:my_movie_list/domain/usecases/get_movie_detail.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  GetMovieDetail usecase;
  MockMoviesRepository mockMoviesRepository;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    usecase = GetMovieDetail(mockMoviesRepository);
  });

  final tLanguage = MoviesApi.en;
  final tMovieId = 399566;
  final tMovie = Movie();

  test(
    'should get a movie from repository',
    () async {
      // arrange
      when(mockMoviesRepository.getMovieDetail(any, any))
          .thenAnswer((_) async => Right(tMovie));
      // act
      final result = await usecase(
        MovieDetailParams(language: tLanguage, movieId: tMovieId),
      );
      // assert
      expect(result, Right(tMovie));
      verify(mockMoviesRepository.getMovieDetail(tLanguage, tMovieId));
      verifyNoMoreInteractions(mockMoviesRepository);
    },
  );
}
