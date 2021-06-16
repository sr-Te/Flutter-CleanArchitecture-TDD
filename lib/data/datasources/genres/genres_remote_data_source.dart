import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/errors/exception.dart';
import '../../../core/api/movies_api.dart';
import '../../models/genre_model.dart';

abstract class GenresRemoteDataSource {
  Future<List<GenreModel>> getGenres(String language);
}

class GenresRemoteDataSourceImpl implements GenresRemoteDataSource {
  final http.Client client;

  GenresRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<GenreModel>> getGenres(String language) async {
    final response = await client.get(MoviesApi.getGenres(language));
    if (response.statusCode == 200)
      return genreModelListFromJsonList(json.decode(response.body)['genres']);
    else
      throw ServerException();
  }
}
