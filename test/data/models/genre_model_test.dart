import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/data/models/genre_model.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tGenreModel = GenreModel(id: 0, name: 'test');
  final tGenreModelList = [tGenreModel];

  test('should be a subclass of Genre entity', () async {
    // assert
    expect(tGenreModel, isA<Genre>());
  });

  group('fromJson', () {
    test(
      'shoul return a valid model when the JSON is a genre',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('genres.json'));
        // act
        final result = GenreModel.fromJson(jsonMap['genres'][0]);
        // assert
        expect(result, isA<GenreModel>());
      },
    );

    test(
      'shoul return a List<GenreModel> when the JSON contains a List of genre',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('genres.json'));
        // act
        final result = genreModelListFromJsonList(jsonMap['genres']);
        // assert
        expect(result, isA<List<GenreModel>>());
      },
    );
  });
}
