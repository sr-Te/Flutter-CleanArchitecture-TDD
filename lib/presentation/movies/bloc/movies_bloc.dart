import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/core/globals/failure_message.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/movie_model.dart';
import '../../../domain/usecases/get_movies.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovies getMovies;

  MoviesBloc({
    @required this.getMovies,
  })  : assert(getMovies != null),
        super(MoviesInitial());

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is MoviesGet) yield* _moviesGet(event);
  }

  Stream<MoviesState> _moviesGet(MoviesGet event) async* {
    yield MoviesLoadInProgress();
    final failureOrMovies = await getMovies(
      Params(endpoint: event.endpoint, language: event.language),
    );
    yield failureOrMovies.fold(
      (failure) => MoviesLoadFailure(message: _mapFailureToMessage(failure)),
      (movies) => MoviesLoadSuccess(movieList: movies),
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
