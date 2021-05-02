class MoviesApi {
  static String _apikey = '4936b271d28ceb320ef9e012cf1363d7';
  static String _url = 'api.themoviedb.org';

  // languages
  static const String es = 'es-ES';
  static const String en = 'en-US';

  // Uris
  static Uri getMovies(String endpoint, String language) => Uri.https(
        _url,
        endpoint,
        {'api_key': _apikey, 'language': language},
      );

  static Uri getGenres(String language) => Uri.https(
        _url,
        '3/genre/movie/list',
        {'api_key': _apikey, 'language': language},
      );

  // Img / Posters
  static String getMoviePoster(String posterPath) {
    if (posterPath == null) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  static String getMovieBackgroundImg(String backdropPath) {
    if (backdropPath == null) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}

class MoviesEndpoint {
  static const String nowPlaying = '3/movie/now_playing';
  static const String popular = '3/movie/popular';
  static const String topRated = '3/movie/top_rated';
  static const String upcoming = '3/movie/upcoming';
}
