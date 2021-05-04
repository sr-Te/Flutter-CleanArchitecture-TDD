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
    int genre,
  );
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<MovieModel>> getMovies(
    String endpoint,
    String language,
    int genre,
  ) async {
    final response = await client.get(
      MoviesApi.getMovies(endpoint: endpoint, language: language, genre: genre),
    );
    if (response.statusCode == 200)
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    else
      throw ServerException();
  }
}
