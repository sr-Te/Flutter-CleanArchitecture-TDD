part of 'movies_nav_cubit.dart';

abstract class MoviesNavState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesNavPopular extends MoviesNavState {}

class MoviesNavTopRated extends MoviesNavState {}

class MoviesNavNowPlaying extends MoviesNavState {}

class MoviesNavUpComing extends MoviesNavState {}

class MoviesNavWithGenres extends MoviesNavState {
  final Genre genre;
  MoviesNavWithGenres(this.genre);

  @override
  List<Object> get props => [genre];
}
