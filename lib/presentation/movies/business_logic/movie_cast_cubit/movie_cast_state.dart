part of 'movie_cast_cubit.dart';

abstract class MovieCastState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieCastLoadInProgress extends MovieCastState {}

class MovieCastLoadSuccess extends MovieCastState {
  final List<Actor> cast;
  MovieCastLoadSuccess({@required this.cast});

  @override
  List<Object> get props => [cast];
}

class MovieCastLoadFailure extends MovieCastState {
  final String message;
  MovieCastLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
