class MoviesApi {
  static String _apikey = '4936b271d28ceb320ef9e012cf1363d7';
  static String _url = 'api.themoviedb.org';

  // languages
  static String es = 'es-ES';
  static String en = 'en-US';

  // Uris
  static Uri getMovies(String endpoint, String language) => Uri.https(
        _url,
        endpoint,
        {'api_key': _apikey, 'language': language},
      );

  static String getMoviePoster(String posterPath) {
    if (posterPath == null) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }
}

class MoviesEndpoint {
  static String nowPlaying = '3/movie/now_playing';
}
