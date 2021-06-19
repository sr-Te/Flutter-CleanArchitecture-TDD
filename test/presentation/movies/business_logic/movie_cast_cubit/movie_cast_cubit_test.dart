import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/domain/entities/actor.dart';
import 'package:my_movie_list/domain/usecases/get_movie_cast.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movie_cast_cubit/movie_cast_cubit.dart';

class MockGetMovieCast extends Mock implements GetMovieCast {}

void main() {
  MovieCastCubit cubit;
  MockGetMovieCast mockGetMovieCast;

  setUp(() {
    mockGetMovieCast = MockGetMovieCast();
    cubit = MovieCastCubit(getMovieCast: mockGetMovieCast);
  });

  test(
    'initState should be MovieCastLoadInProgress',
    () {
      // assert
      expect(cubit.state, equals(MovieCastLoadInProgress()));
    },
  );

  group('getMovieCast', () {
    final tCast = [Actor()];
    final tLanguage = MoviesApi.en;
    final tMovieId = 399566;

    test(
      'should get data from getMovieCast usecase',
      () async {
        // arrange
        when(mockGetMovieCast(any)).thenAnswer((_) async => Right(tCast));
        // act
        cubit.movieCastGet(language: tLanguage, movieId: tMovieId);
        await untilCalled(mockGetMovieCast(any));
        // assert
        verify(mockGetMovieCast(
          CastParams(language: tLanguage, movieId: tMovieId),
        ));
      },
    );

    test(
      'should emit [MovieCastLoadInProgress, MovieCastLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMovieCast(any)).thenAnswer((_) async => Right(tCast));
        // assert
        final expected = [
          MovieCastLoadInProgress(),
          MovieCastLoadSuccess(cast: tCast),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieCastGet(language: tLanguage, movieId: tMovieId);
      },
    );

    test(
      'should emit [MovieCastLoadInProgress, MovieCastLoadFailure] when getting data fails',
      () async {
        // arrange
        when(mockGetMovieCast(any)).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
        // assert layer
        final expected = [
          MovieCastLoadInProgress(),
          MovieCastLoadFailure(message: FailureMessage.server),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieCastGet(language: tLanguage, movieId: tMovieId);
      },
    );

    test(
      'should emit [MoviesCastLoadInProgress, MoviesCastLoadFailure] when there is no internet',
      () async {
        // arrange
        when(mockGetMovieCast(any)).thenAnswer(
          (_) async => Left(InternetFailure()),
        );
        // assert layer
        final expected = [
          MovieCastLoadInProgress(),
          MovieCastLoadFailure(message: FailureMessage.internet),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieCastGet(language: tLanguage, movieId: tMovieId);
      },
    );
  });
}
