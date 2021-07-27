import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/api/movies_api.dart';
import '../../../core/errors/exception.dart';
import '../../../domain/entities/actor.dart';
import '../../../domain/entities/movie.dart';

abstract class MoviesRemoteDataSource {
  Future<List<Movie>> getMovies(
    String endpoint,
    String language,
    int genreId,
  );

  Future<List<Movie>> searchMovies(
    String language,
    String query,
  );

  Future<Movie> getMovieDetail(String language, int movieId);

  Future<List<Actor>> getMovieCast(String language, int movieId);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;

  MoviesRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<Movie>> getMovies(
    String endpoint,
    String language,
    int genreId,
  ) async {
    final response = await client.get(
      MoviesApi.getMovies(endpoint, language, genreId),
    );
    if (response.statusCode == 200)
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    else {
      print(response.statusCode);
      print(response.body);
      throw ServerException();
    }
  }

  @override
  Future<List<Movie>> searchMovies(String language, String query) async {
    final response = await client.get(MoviesApi.searchMovies(language, query));
    if (response.statusCode == 200) {
      return movieModelListFromJsonList(json.decode(response.body)['results']);
    } else
      throw ServerException();
  }

  @override
  Future<Movie> getMovieDetail(String language, int movieId) async {
    final response = await client.get(
      MoviesApi.getMovieDetail(language, movieId),
    );
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else
      throw ServerException();
  }

  @override
  Future<List<Actor>> getMovieCast(String language, int movieId) async {
    final response = await client.get(
      MoviesApi.getMovieCast(language, movieId),
    );
    if (response.statusCode == 200) {
      return actorModelListFromJsonList(json.decode(response.body)['cast']);
    } else
      throw ServerException();
  }
}
