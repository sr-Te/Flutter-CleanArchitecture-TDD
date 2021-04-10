class MoviesApi {
  static String _apikey = '4936b271d28ceb320ef9e012cf1363d7';
  static String _url = 'api.themoviedb.org';

  // languages
  static String es = 'es-ES';
  static String en = 'en-US';

  // Uris
  static Uri getMoviesNowPlayingUri(String language) => Uri.https(
        _url,
        '3/movie/now_playing',
        {'api_key': _apikey, 'language': language},
      );
}
