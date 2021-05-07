import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/domain/entities/genre.dart';
import 'package:my_movie_list/domain/usecases/get_genres.dart';
import 'package:my_movie_list/presentation/genres/business_logic/genres_cubit.dart';

class MockGetGenres extends Mock implements GetGenres {}

void main() {
  GenresCubit cubit;
  MockGetGenres mockGetGenres;

  setUp(() {
    mockGetGenres = MockGetGenres();
    cubit = GenresCubit(getGenres: mockGetGenres);
  });

  test('initialState should be GenresInitial', () {
    // assert
    expect(cubit.state, equals(GenresInitial()));
  });

  group('genresGet', () {
    final List<Genre> tGenreList = [];
    final tLanguage = MoviesApi.en;

    test(
      'should get data from getGenres usecase',
      () async {
        // arrange
        when(mockGetGenres(any)).thenAnswer((_) async => Right(tGenreList));
        // act
        cubit.genresGet(language: tLanguage);
        await untilCalled(mockGetGenres(any));
        // assert
        verify(mockGetGenres(Params(language: tLanguage)));
      },
    );

    test(
      'should emit [GenresLoadInProgress, GenresLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetGenres(any)).thenAnswer((_) async => Right(tGenreList));
        // act
        final expected = [
          GenresLoadInProgress(),
          GenresLoadSuccess(genres: tGenreList),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        // assert
        cubit.genresGet(language: tLanguage);
      },
    );

    test(
      'should emit [GenresLoadInProgress, GenresLoadFailure] when data is gotten unsuccessfully',
      () async {
        // arrange
        when(mockGetGenres(any)).thenAnswer((_) async => Left(ServerFailure()));
        // act
        final expected = [
          GenresLoadInProgress(),
          GenresLoadFailure(message: FailureMessage.server),
        ];
        expectLater(cubit.stream, emitsInOrder(expected));
        // assert
        cubit.genresGet(language: tLanguage);
      },
    );
  });
}
