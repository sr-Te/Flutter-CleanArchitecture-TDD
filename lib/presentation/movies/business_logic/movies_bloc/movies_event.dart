part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesGet extends MoviesEvent {
  final String endpoint;
  final String language;
  final int genre;

  MoviesGet({this.endpoint, this.language, this.genre = -1});

  @override
  List<Object> get props => [this.endpoint, this.language, this.genre];
}
