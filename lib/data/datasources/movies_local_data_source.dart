import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie_model.dart';

abstract class MoviesLocalDataSource {
  Future<MovieListModel> getLastMovies(String endpoint);
  Future<void> cacheMovies(String endpoint, MovieListModel moviesToCache);
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheMovies(String endpoint, MovieListModel moviesToCache) {
    return sharedPreferences.setString(
        endpoint, json.encode(moviesToCache.toJson()));
  }

  @override
  Future<MovieListModel> getLastMovies(String endpoint) {
    final jsonString = sharedPreferences.getString(endpoint);
    if (jsonString != null) {
      return Future.value(MovieListModel.fromJsonList(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
