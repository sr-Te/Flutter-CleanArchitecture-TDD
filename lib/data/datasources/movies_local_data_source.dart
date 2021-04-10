import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie_model.dart';

abstract class MoviesLocalDataSource {
  Future<MovieListModel> getLastMoviesNowPlaying();
  Future<void> cacheMovies(MovieListModel moviesToCache);
}

const CACHED_MOVIES_NOW_PLAYING = 'CACHED_MOVIES_NOW_PLAYING';

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MoviesLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheMovies(MovieListModel moviesToCache) {
    return sharedPreferences.setString(
        CACHED_MOVIES_NOW_PLAYING, json.encode(moviesToCache.toJson()));
  }

  @override
  Future<MovieListModel> getLastMoviesNowPlaying() {
    final jsonString = sharedPreferences.getString(CACHED_MOVIES_NOW_PLAYING);
    if (jsonString != null) {
      return Future.value(MovieListModel.fromJsonList(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
