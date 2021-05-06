import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/errors/exception.dart';
import '../../../core/network/api/movies_api.dart';
import '../../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies(
    String endpoint,
    String language,
    int genreId,
  );

  Future<List<MovieModel>> searchMovies(
    String language,
    String query,
  );
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<MovieModel>> getMovies(
    String endpoint,
    String language,
    int genreId,
  ) async {
    final response = await client.get(
      MoviesApi.getMovies(endpoint, language, genreId),
    );
    if (response.statusCode == 200)
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    else
      throw ServerException();
  }

  @override
  Future<List<MovieModel>> searchMovies(String language, String query) async {
    final response = await client.get(MoviesApi.searchMovies(language, query));
    if (response.statusCode == 200) {
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    } else
      throw ServerException();
  }
}
