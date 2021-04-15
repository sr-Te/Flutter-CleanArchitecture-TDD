import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/exception.dart';
import '../../core/globals/movies_api.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<MovieListModel> getMovies(String endpoint, String language);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({@required this.client});

  @override
  Future<MovieListModel> getMovies(
    String endpoint,
    String language,
  ) async {
    final response = await client.get(MoviesApi.getMovies(endpoint, language));

    if (response.statusCode == 200)
      return MovieListModel.fromJsonList(json.decode(response.body)['results']);
    else
      throw ServerException();
  }
}
