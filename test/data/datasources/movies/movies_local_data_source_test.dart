import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/api/movies_endpoint.dart';
import 'package:my_movie_list/data/datasources/movies/movies_local_data_source.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MoviesLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = MoviesLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final tEndpoint = MoviesEndpoint.withGenre;

  group('getLastMovies', () {
    test(
      'should return List<Movie> from SharedPreferences when is at least one movie in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('movies_cached.json'));
        // act
        final result = await dataSource.getLastMovies(tEndpoint);
        // assert
        verify(mockSharedPreferences.getString(tEndpoint));
        expect(result, isA<List<Movie>>());
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastMovies;
        // assert
        expect(() => call(tEndpoint), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheMovies', () {
    final List<Movie> tMovieListModel = [];

    test(
      'should call SharedPreferences to cache the data',
      () {
        // act
        dataSource.cacheMovies(tEndpoint, tMovieListModel);
        // assert
        final expectedJsonString = json.encode(
          movieModelListToJsonList(tMovieListModel),
        );
        verify(mockSharedPreferences.setString(
          tEndpoint,
          expectedJsonString,
        ));
      },
    );
  });
}
