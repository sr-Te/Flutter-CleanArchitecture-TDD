import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/errors/exception.dart';
import '../../models/movie_model.dart';
import '../movies_api.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies(String endpoint, String language);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<MovieModel>> getMovies(String endpoint, String language) async {
    final response = await client.get(
      MoviesApi.getMovies(endpoint, language),
    );
    if (response.statusCode == 200)
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    else
      throw ServerException();
  }
}
