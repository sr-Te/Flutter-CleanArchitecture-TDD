import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/data/datasources/genres/genres_remote_data_source.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  GenresRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = GenresRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response(
        fixture('genres.json'),
        200,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      ),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getGenres', () {
    final tLanguage = MoviesApi.es;

    test(
      'should preform a GET request on a URL',
      () {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getGenres(tLanguage);
        // assert
        verify(mockHttpClient.get(MoviesApi.getGenres(tLanguage)));
      },
    );

    test(
      'shoud return a List<Genre> when the Response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getGenres(tLanguage);
        // assert
        expect(result, isA<List<Genre>>());
      },
    );

    test(
      'should throw a ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getGenres;
        // assert
        expect(
          () => call(tLanguage),
          throwsA(TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
