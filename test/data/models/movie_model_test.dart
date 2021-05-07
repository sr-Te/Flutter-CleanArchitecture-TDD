import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/entities/movie.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tMovieModel = MovieModel();

  test('should be a subclass of Movie entity', () async {
    // assert
    expect(tMovieModel, isA<Movie>());
  });

  group('fromJson', () {
    test(
      'shoul return a valid model when the JSON is a model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('movies_now_playing.json'));
        // act
        final result = MovieModel.fromJson(jsonMap['results'][0]);
        // assert
        expect(result, isA<MovieModel>());
      },
    );

    test(
      'shoul return a List<MovieModel> when the JSON contains a List of movie',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('movies_now_playing.json'));
        // act
        final result = movieModelListFromJsonList(jsonMap['results']);
        // assert
        expect(result, isA<List<MovieModel>>());
      },
    );
  });
}
