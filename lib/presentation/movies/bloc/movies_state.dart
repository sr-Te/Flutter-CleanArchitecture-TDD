part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyMovies extends MoviesState {}

class LoadingMovies extends MoviesState {}

class LoadedMovies extends MoviesState {
  final MovieListModel movieList;
  LoadedMovies({@required this.movieList});
}

class ErrorMovies extends MoviesState {
  final String message;
  ErrorMovies({@required this.message});
}
