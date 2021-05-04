import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

part 'movies_nav_state.dart';

class MoviesNavCubit extends Cubit<MoviesNavState> {
  MoviesNavCubit() : super(MoviesNavPopular());

  void getMoviesTopRated() => emit(MoviesNavTopRated());
  void getMoviesPopular() => emit(MoviesNavPopular());
  void getMoviesNowPlaying() => emit(MoviesNavNowPlaying());
  void getMoviesUpcoming() => emit(MoviesNavUpComing());
  void getWithGenres(Genre genre) => emit(MoviesNavWithGenres(genre));
}
