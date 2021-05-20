part of 'movie_details_cubit.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailsLoadInProgress extends MovieDetailsState {}

class MovieDetailsLoadSuccess extends MovieDetailsState {
  final Movie movie;
  MovieDetailsLoadSuccess({@required this.movie});

  @override
  List<Object> get props => [movie];
}

class MovieDetailsLoadFailure extends MovieDetailsState {
  final String message;
  MovieDetailsLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
