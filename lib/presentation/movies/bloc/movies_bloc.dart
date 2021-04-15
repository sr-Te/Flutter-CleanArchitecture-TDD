import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/core/globals/failure_message.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/movie_model.dart';
import '../../../domain/usecases/get_movies_now_playing.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesNowPlaying getMoviesNowPlaying;

  MoviesBloc({
    @required GetMoviesNowPlaying nowPlaying,
  })  : assert(nowPlaying != null),
        getMoviesNowPlaying = nowPlaying,
        super(EmptyMovies());

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is GetNowPlaying) yield* _getNowPlaying(event);
  }

  Stream<MoviesState> _getNowPlaying(GetNowPlaying event) async* {
    yield LoadingMovies();
    final failureOrMovies = await getMoviesNowPlaying(
      Params(language: event.language),
    );
    yield failureOrMovies.fold(
      (failure) => ErrorMovies(message: _mapFailureToMessage(failure)),
      (movies) => LoadedMovies(movieList: movies),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return FailureMessage.server;
      default:
        return FailureMessage.unexpected;
    }
  }
}
