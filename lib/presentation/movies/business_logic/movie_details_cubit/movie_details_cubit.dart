import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_movie_detail.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailsCubit({@required this.getMovieDetail})
      : assert(getMovieDetail != null),
        super(MovieDetailsLoadInProgress());

  Future<void> movieDetailsGet({String language, int movieId}) async {
    emit(MovieDetailsLoadInProgress());
    final failureOrMovie = await getMovieDetail(
      MovieDetailParams(movieId: movieId, language: language),
    );
    failureOrMovie.fold(
      (failure) => emit(
        MovieDetailsLoadFailure(message: mapFailureToMessage(failure)),
      ),
      (movie) => emit(MovieDetailsLoadSuccess(movie: movie)),
    );
  }
}
