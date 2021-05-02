part of 'genres_cubit.dart';

abstract class GenresState extends Equatable {
  @override
  List<Object> get props => [];
}

class GenresInitial extends GenresState {}

class GenresLoadInProgress extends GenresState {}

class GenresLoadSuccess extends GenresState {
  final List<Genre> genres;
  GenresLoadSuccess({@required this.genres});

  @override
  List<Object> get props => [this.genres];
}

class GenresLoadFailure extends GenresState {
  final String message;
  GenresLoadFailure({@required this.message});

  @override
  List<Object> get props => [this.message];
}
