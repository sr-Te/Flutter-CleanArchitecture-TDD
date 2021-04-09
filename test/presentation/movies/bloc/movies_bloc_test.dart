import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/util/globals/movies_api.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/usecases/get_movies_now_playing.dart';
import 'package:my_movie_list/presentation/movies/bloc/movies_bloc.dart';

class MockGetMoviesNowPlaying extends Mock implements GetMoviesNowPlaying {}

void main() {
  MoviesBloc bloc;
  MockGetMoviesNowPlaying mockGetMoviesNowPlaying;

  setUp(() {
    mockGetMoviesNowPlaying = MockGetMoviesNowPlaying();
    bloc = MoviesBloc(nowPlaying: mockGetMoviesNowPlaying);
  });

  test('initialState should be EmptyMovies', () {
    // assert
    expect(bloc.initialState, equals(EmptyMovies()));
  });

  group('GetNowPlaying', () {
    final tMovieList = MovieListModel();
    final tLanguage = MoviesApi.en;

    test(
      'should get data from nowPlaying usecase',
      () async {
        // arrange
        when(mockGetMoviesNowPlaying(any))
            .thenAnswer((_) async => Right(tMovieList));
        // act
        bloc.add(GetNowPlaying(tLanguage));
        await untilCalled(mockGetMoviesNowPlaying(any));
        // assert
        verify(mockGetMoviesNowPlaying(Params(language: tLanguage)));
      },
    );

    test(
      'should emit [LoadingMovies, LoadedMovies] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMoviesNowPlaying(any))
            .thenAnswer((_) async => Right(tMovieList));
        // assert layer
        final expected = [
          EmptyMovies(),
          LoadingMovies(),
          LoadedMovies(movieList: tMovieList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(GetNowPlaying(tLanguage));
      },
    );
    test(
      'should emit [LoadingMovies, ErrorMovies] when getting data fails',
      () async {
        // arrange
        when(mockGetMoviesNowPlaying(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert layer
        final expected = [
          EmptyMovies(),
          LoadingMovies(),
          ErrorMovies(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(GetNowPlaying(tLanguage));
      },
    );
  });
}
