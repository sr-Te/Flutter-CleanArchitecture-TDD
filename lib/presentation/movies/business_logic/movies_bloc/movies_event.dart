part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesGet extends MoviesEvent {
  final String endpoint;
  final String language;
  MoviesGet(this.endpoint, this.language);
}
