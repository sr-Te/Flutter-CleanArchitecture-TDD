import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exception.dart';
import '../../models/movie_model.dart';

abstract class MoviesLocalDataSource {
  Future<List<MovieModel>> getLastMovies(String endpoint);
  Future<void> cacheMovies(String endpoint, List<MovieModel> moviesToCache);
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheMovies(String endpoint, List<MovieModel> moviesToCache) {
    return sharedPreferences.setString(
      endpoint,
      json.encode(movieModelListToJsonList(moviesToCache)),
    );
  }

  @override
  Future<List<MovieModel>> getLastMovies(String endpoint) {
    final jsonString = sharedPreferences.getString(endpoint);
    if (jsonString != null) {
      return Future.value(movieModelListFromJsonList(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
