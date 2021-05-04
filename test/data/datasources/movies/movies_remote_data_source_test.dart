import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/network/api/movies_api.dart';
import 'package:my_movie_list/core/network/api/movies_endpoint.dart';
import 'package:my_movie_list/data/datasources/movies/movies_remote_data_source.dart';
import 'package:my_movie_list/data/models/movie_model.dart';

import '../../../fixtures/fixture_reader.dart';

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

  group('getMovies', () {
    final tLanguage = MoviesApi.es;
    final tEndpoint = MoviesEndpoint.nowPlaying;

    test(
      'should preform a GET request on a URL',
      () {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getMovies(tEndpoint, tLanguage, -1);
        // assert
        verify(mockHttpClient.get(
          MoviesApi.getMovies(tEndpoint, tLanguage, -1),
        ));
      },
    );

    test(
      'should return List<MovieModel> when response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getMovies(tEndpoint, tLanguage, -1);
        // arrange
        expect(result, isA<List<MovieModel>>());
      },
    );

    test(
      'should throw a ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getMovies;
        // assert
        expect(
          () => call(tEndpoint, tLanguage, -1),
          throwsA(TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
