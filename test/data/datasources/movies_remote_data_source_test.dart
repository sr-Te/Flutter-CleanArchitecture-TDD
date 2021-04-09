import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/util/globals/movies_api.dart';
import 'package:my_movie_list/data/datasources/movies_remote_data_source.dart';
import 'package:my_movie_list/data/models/movie_model.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MoviesRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MoviesRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response(
        fixture('movies_now_playing.json'),
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

  group('getMoviesNowPlaying', () {
    final tLanguage = 'en-US';

    test(
      'should preform a GET request on a URL',
      () {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getMoviesNowPlaying(tLanguage);
        // assert
        verify(mockHttpClient.get(
          MoviesApi.getMoviesNowPlayingUri(tLanguage),
        ));
      },
    );

    test(
      'should return MovieListModel when response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getMoviesNowPlaying(tLanguage);
        // arrange
        expect(result, isA<MovieListModel>());
      },
    );

    test(
      'should throw a ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getMoviesNowPlaying;
        // assert
        expect(() => call(tLanguage), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
