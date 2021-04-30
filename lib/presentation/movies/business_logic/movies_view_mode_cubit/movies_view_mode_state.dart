part of 'movies_view_mode_cubit.dart';

abstract class MoviesViewModeState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesViewByOneMode extends MoviesViewModeState {
  final int index;

  MoviesViewByOneMode({@required this.index});

  @override
  List<Object> get props => [index];
}

class MoviesViewGridMode extends MoviesViewModeState {}
