import 'package:flutter_bloc/flutter_bloc.dart';

enum MovieCategory { topRated, popular, nowPlaying, upComing }

class MoviesNavCubit extends Cubit<MovieCategory> {
  MoviesNavCubit() : super(MovieCategory.popular);

  void getMoviesTopRated() => emit(MovieCategory.topRated);
  void getMoviesPopular() => emit(MovieCategory.popular);
  void getMoviesNowPlaying() => emit(MovieCategory.nowPlaying);
  void getMoviesUpcoming() => emit(MovieCategory.upComing);
}
