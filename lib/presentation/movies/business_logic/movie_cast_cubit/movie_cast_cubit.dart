import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../domain/entities/actor.dart';
import '../../../../domain/usecases/get_movie_cast.dart';

part 'movie_cast_state.dart';

class MovieCastCubit extends Cubit<MovieCastState> {
  final GetMovieCast getMovieCast;

  MovieCastCubit({@required this.getMovieCast})
      : assert(getMovieCast != null),
        super(MovieCastLoadInProgress());

  Future<void> movieCastGet({String language, int movieId}) async {
    emit(MovieCastLoadInProgress());
    final failureOrMovie = await getMovieCast(
      CastParams(movieId: movieId, language: language),
    );
    failureOrMovie.fold(
      (failure) => emit(
        MovieCastLoadFailure(message: mapFailureToMessage(failure)),
      ),
      (cast) => emit(MovieCastLoadSuccess(cast: cast)),
    );
  }
}
