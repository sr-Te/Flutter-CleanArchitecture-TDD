part of 'movies_search_cubit.dart';

abstract class MoviesSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesSearchInitial extends MoviesSearchState {}

class MoviesSearchLoadInProgress extends MoviesSearchState {}

class MoviesSearchLoadSuccess extends MoviesSearchState {
  final List<Movie> movies;
  MoviesSearchLoadSuccess({this.movies});

  @override
  List<Object> get props => [this.movies];
}

class MoviesSearchLoadFailure extends MoviesSearchState {
  final String message;
  MoviesSearchLoadFailure({this.message});

  @override
  List<Object> get props => [this.message];
}
