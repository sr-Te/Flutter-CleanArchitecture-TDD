import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/usecases/search_movies.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_search_cubit/movies_search_cubit.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  MoviesSearchCubit cubit;
  MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    cubit = MoviesSearchCubit(searchMovies: mockSearchMovies);
  });

  test(
    'initState should be MoviesSearchInitial ',
    () {
      // assert
      expect(cubit.state, equals(MoviesSearchInitial()));
    },
  );

  group('moviesSearchRestart', () {
    test(
      'should emit MoviesSearchInitial when it is call',
      () async {
        // act
        cubit.moviesSearchRestart();
        // assert
        expect(cubit.state, equals(MoviesSearchInitial()));
      },
    );
  });

  group('searchMovies', () {
    String tLanguage = MoviesApi.es;
    String tQuery = 'k';
    final List<Movie> tMovieList = [];

    test(
      'should get data from searchMovies usecase',
      () async {
        // arrange
        when(mockSearchMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // act
        cubit.moviesSearch(language: tLanguage, query: tQuery);
        await untilCalled(mockSearchMovies(any));
        // assert
        verify(mockSearchMovies(
          SearchMoviesParams(language: tLanguage, query: tQuery),
        ));
      },
    );

    test(
      'should emit [MoviesSearchLoadInProgress, MoviesSearchLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockSearchMovies(any)).thenAnswer((_) async => Right(tMovieList));
        // assert
        final expected = [
          MoviesSearchLoadInProgress(),
          MoviesSearchLoadSuccess(movies: tMovieList),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.moviesSearch(language: tLanguage, query: tQuery);
      },
    );

    test(
      'should emit [MoviesSearchLoadInProgress, MoviesSearchLoadFailure] when getting data fails',
      () async {
        // arrange
        when(mockSearchMovies(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert layer
        final expected = [
          MoviesSearchLoadInProgress(),
          MoviesSearchLoadFailure(message: FailureMessage.server),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.moviesSearch(language: tLanguage, query: tQuery);
      },
    );

    test(
      'should emit [MoviesSearchLoadInProgress, MoviesSearchLoadFailure] when there is no internet',
      () async {
        // arrange
        when(mockSearchMovies(any))
            .thenAnswer((_) async => Left(InternetFailure()));
        // assert layer
        final expected = [
          MoviesSearchLoadInProgress(),
          MoviesSearchLoadFailure(message: FailureMessage.internet),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.moviesSearch(language: tLanguage, query: tQuery);
      },
    );
  });
}
