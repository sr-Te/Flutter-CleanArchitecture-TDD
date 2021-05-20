import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:my_movie_list/domain/usecases/get_movie_detail.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movie_details_cubit/movie_details_cubit.dart';

class MockGetMovieDetails extends Mock implements GetMovieDetail {}

void main() {
  MovieDetailsCubit cubit;
  MockGetMovieDetails mockGetMovieDetails;

  setUp(() {
    mockGetMovieDetails = MockGetMovieDetails();
    cubit = MovieDetailsCubit(getMovieDetail: mockGetMovieDetails);
  });

  test(
    'initState should be MoviesSearchInitial ',
    () {
      // assert
      expect(cubit.state, equals(MovieDetailsLoadInProgress()));
    },
  );

  group('getMovieDetail', () {
    final tLanguage = MoviesApi.en;
    final tMovieId = 399566;
    final tMovie = Movie();

    test(
      'should get data from getMovieDetail usecase',
      () async {
        // arrange
        when(mockGetMovieDetails(any)).thenAnswer((_) async => Right(tMovie));
        // act
        cubit.movieDetailsGet(language: tLanguage, movieId: tMovieId);
        await untilCalled(mockGetMovieDetails(any));
        // assert
        verify(mockGetMovieDetails(
          MovieDetailParams(language: tLanguage, movieId: tMovieId),
        ));
      },
    );

    test(
      'should emit [MovieDetailsLoadInProgress, MovieDetailsLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMovieDetails(any)).thenAnswer((_) async => Right(tMovie));
        // assert
        final expected = [
          MovieDetailsLoadInProgress(),
          MovieDetailsLoadSuccess(movie: tMovie),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieDetailsGet(language: tLanguage, movieId: tMovieId);
      },
    );

    test(
      'should emit [MovieDetailsLoadInProgress, MovieDetailsLoadFailure] when getting data fails',
      () async {
        // arrange
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert layer
        final expected = [
          MovieDetailsLoadInProgress(),
          MovieDetailsLoadFailure(message: FailureMessage.server),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieDetailsGet(language: tLanguage, movieId: tMovieId);
      },
    );

    test(
      'should emit [MoviesSearchLoadInProgress, MoviesSearchLoadFailure] when there is no internet',
      () async {
        // arrange
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(InternetFailure()));
        // assert layer
        final expected = [
          MovieDetailsLoadInProgress(),
          MovieDetailsLoadFailure(message: FailureMessage.internet),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        //act
        cubit.movieDetailsGet(language: tLanguage, movieId: tMovieId);
      },
    );
  });
}
