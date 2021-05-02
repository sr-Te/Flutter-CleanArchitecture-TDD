import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/data/datasources/genres/genres_local_data_source.dart';
import 'package:my_movie_list/data/models/genre_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  GenresLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = GenresLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastGenres', () {
    test(
      'should return List<GenreModel> from SharedPreferences when is at least one movie in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('genres_cached.json'));
        // act
        final result = await dataSource.getLastGenres();
        // assert
        verify(mockSharedPreferences.getString(CACHED_GENRES));
        expect(result, isA<List<GenreModel>>());
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastGenres;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheGenres', () {
    final List<GenreModel> tGenreListModel = [];

    test(
      'should call SharedPreferences to cache the data',
      () {
        // act
        dataSource.cacheGenres(tGenreListModel);
        // assert
        final expectedJsonString = json.encode(
          genreModelListToJsonList(tGenreListModel),
        );
        verify(mockSharedPreferences.setString(
          CACHED_GENRES,
          expectedJsonString,
        ));
      },
    );
  });
}
