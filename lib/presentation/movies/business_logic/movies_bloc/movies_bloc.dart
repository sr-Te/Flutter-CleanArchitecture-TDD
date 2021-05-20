import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_movies.dart';

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
      Params(
          endpoint: event.endpoint,
          language: event.language,
          genreId: event.genre),
    );
    yield failureOrMovies.fold(
      (failure) => MoviesLoadFailure(message: mapFailureToMessage(failure)),
      (movies) => MoviesLoadSuccess(movies: movies),
    );
  }
}
