part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoadInProgress extends MoviesState {}

class MoviesLoadSuccess extends MoviesState {
  final MovieListModel movieList;
  MoviesLoadSuccess({@required this.movieList});
}

class MoviesLoadFailure extends MoviesState {
  final String message;
  MoviesLoadFailure({@required this.message});
}
