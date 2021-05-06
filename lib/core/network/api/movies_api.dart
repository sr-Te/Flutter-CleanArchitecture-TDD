import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/domain/entities/movie.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

class MoviesApi {
  static String _apikey = '4936b271d28ceb320ef9e012cf1363d7';
  static String _url = 'api.themoviedb.org';

  // languages
  static const String es = 'es-ES';
  static const String en = 'en-US';

  // Uris
  static Uri getMovies(String endpoint, String language, int genreId) =>
      Uri.https(_url, endpoint, _getParameters(language, genreId));

  static Uri getGenres(String language) => Uri.https(
      _url, '3/genre/movie/list', {'api_key': _apikey, 'language': language});

  static Uri searchMovies(String langugage, String query) => Uri.https(_url,
      '3/search/movie', {'api_key': _apikey, 'language': es, 'query': query});

  // Img / Posters
  static String getMoviePoster(String posterPath) {
    if (posterPath == null)
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    else
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
  }

  static String getMovieBackgroundImg(String backdropPath) {
    if (backdropPath == null)
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    else
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
  }

  static Map<String, dynamic> _getParameters(String language, int genreId) {
    var parameters = {'api_key': _apikey, 'language': language};
    if (genreId == null || genreId == -1)
      return parameters;
    else {
      parameters['with_genres'] = '$genreId';
      return parameters;
    }
  }

  static Future<List<Movie>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': es, 'query': query});

    final response = await http.get(url);
    return movieModelListFromJsonList(json.decode(response.body)['results']);
  }
}
