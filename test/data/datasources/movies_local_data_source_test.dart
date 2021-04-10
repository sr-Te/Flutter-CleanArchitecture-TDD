import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/data/datasources/movies_local_data_source.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

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

  group('getLastMoviesNowPlaying', () {
    final tMovieListModel =
        MovieListModel.fromJsonList(json.decode(fixture('movies_cached.json')));

    test(
      'should return MovieList from SharedPreferences when is at least one movie in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('movies_cached.json'));
        // act
        final result = await dataSource.getLastMoviesNowPlaying();
        // assert
        verify(mockSharedPreferences.getString(CACHED_MOVIES_NOW_PLAYING));
        expect(result, isA<MovieListModel>());
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastMoviesNowPlaying;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheMovies', () {
    final tMovieListModel = MovieListModel();

    test(
      'should call SharedPreferences to cache the data',
      () {
        // act
        dataSource.cacheMoviesNowPlaying(tMovieListModel);
        // assert
        final expectedJsonString = json.encode(tMovieListModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_MOVIES_NOW_PLAYING,
          expectedJsonString,
        ));
      },
    );
  });
}
