part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNowPlaying extends MoviesEvent {
  final String language;
  GetNowPlaying(this.language);
}
