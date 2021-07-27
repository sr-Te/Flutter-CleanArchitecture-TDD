import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/api/movies_api.dart';
import '../../../core/errors/exception.dart';
import '../../../domain/entities/genre.dart';

abstract class GenresRemoteDataSource {
  Future<List<Genre>> getGenres(String language);
}

class GenresRemoteDataSourceImpl implements GenresRemoteDataSource {
  final http.Client client;

  GenresRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<Genre>> getGenres(String language) async {
    final response = await client.get(MoviesApi.getGenres(language));
    if (response.statusCode == 200)
      return genreModelListFromJsonList(json.decode(response.body)['genres']);
    else
      throw ServerException();
  }
}
