import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/globals/failure_message.dart';
import 'package:my_movie_list/data/datasources/movies_api.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/usecases/get_movies.dart';
import 'package:my_movie_list/presentation/movies/bloc/movies_bloc.dart';

class MockGetMovies extends Mock implements GetMovies {}

void main() {
  MoviesBloc bloc;
  MockGetMovies mockGetMovies;

  setUp(() {
    mockGetMovies = MockGetMovies();
    bloc = MoviesBloc(getMovies: mockGetMovies);
  });

  test('initialState should be EmptyMovies', () {
    // assert
    expect(bloc.state, equals(MoviesInitial()));
  });

  group('GetNowPlaying', () {
    final tMovieList = MovieListModel();
    final tLanguage = MoviesApi.en;
    final tEndpoint = MoviesEndpoint.nowPlaying;

    test(
      'should get data from nowPlaying usecase',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // act
        bloc.add(MoviesGet(tEndpoint, tLanguage));
        await untilCalled(mockGetMovies(any));
        // assert
        verify(mockGetMovies(Params(endpoint: tEndpoint, language: tLanguage)));
      },
    );

    test(
      'should emit [LoadingMovies, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // assert layer
        final expected = [
          MoviesLoadInProgress(),
          MoviesLoadSuccess(movieList: tMovieList),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(MoviesGet(tEndpoint, tLanguage));
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
        bloc.add(MoviesGet(tEndpoint, tLanguage));
      },
    );
  });
}
