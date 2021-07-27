import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exception.dart';
import '../../../domain/entities/genre.dart';

abstract class GenresLocalDataSource {
  Future<List<Genre>> getLastGenres();
  Future<void> cacheGenres(List<Genre> moviesToCache);
}

const CACHED_GENRES = 'CACHED_GENRES';

class GenresLocalDataSourceImpl implements GenresLocalDataSource {
  final SharedPreferences sharedPreferences;

  GenresLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheGenres(List<Genre> genresToCache) {
    return sharedPreferences.setString(
      CACHED_GENRES,
      json.encode(genreModelListToJsonList(genresToCache)),
    );
  }

  @override
  Future<List<Genre>> getLastGenres() async {
    final jsonString = sharedPreferences.getString(CACHED_GENRES);
    if (jsonString != null) {
      return Future.value(genreModelListFromJsonList(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
