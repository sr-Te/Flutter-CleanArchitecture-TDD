import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/core/api/movies_endpoint.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/usecases/get_movies.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_bloc/movies_bloc.dart';

class MockGetMovies extends Mock implements GetMovies {}

void main() {
  MoviesBloc bloc;
  MockGetMovies mockGetMovies;

  setUp(() {
    mockGetMovies = MockGetMovies();
    bloc = MoviesBloc(getMovies: mockGetMovies);
  });

  test('initialState should be MoviesInitial', () {
    // assert
    expect(bloc.state, equals(MoviesInitial()));
  });

  group('MoviesGet', () {
    final List<Movie> tMovieList = [];
    final tLanguage = MoviesApi.en;
    final genreId = -1;
    final tEndpoint = MoviesEndpoint.nowPlaying;

    test(
      'should get data from getMovies usecase',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // act
        bloc.add(
          MoviesGet(endpoint: tEndpoint, language: tLanguage, genre: genreId),
        );
        await untilCalled(mockGetMovies(any));
        // assert
        verify(mockGetMovies(Params(
            endpoint: tEndpoint, language: tLanguage, genreId: genreId)));
      },
    );

    test(
      'should emit [MoviesLoadInProgress, MoviesLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // assert
        final expected = [
          MoviesLoadInProgress(),
          MoviesLoadSuccess(movies: tMovieList),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(
          MoviesGet(endpoint: tEndpoint, language: tLanguage, genre: genreId),
        );
      },
    );

    test(
      'should emit [LoadingMovies, ErrorMovies] when getting data fails',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert layer
        final expected = [
          MoviesLoadInProgress(),
          MoviesLoadFailure(message: FailureMessage.server),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(
          MoviesGet(endpoint: tEndpoint, language: tLanguage, genre: genreId),
        );
      },
    );
  });
}
