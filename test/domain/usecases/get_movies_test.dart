import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/core/network/api/movies_endpoint.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/repositories/movies_repository.dart';
import 'package:my_movie_list/domain/usecases/get_movies.dart';

class MockMovieRepository extends Mock implements MoviesRepository {}

void main() {
  GetMovies usecase;
  MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovies(mockMovieRepository);
  });

  final tLanguage = MoviesApi.en;
  final tEndpoint = MoviesEndpoint.nowPlaying;
  final List<MovieModel> tMovieList = [];

  test(
    'shoul get movie list from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMovies(any, any, any))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      final result = await usecase(
          Params(endpoint: tEndpoint, language: tLanguage, genre: -1));
      // assert
      expect(result, Right(tMovieList));
      verify(mockMovieRepository.getMovies(tEndpoint, tLanguage, -1));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
