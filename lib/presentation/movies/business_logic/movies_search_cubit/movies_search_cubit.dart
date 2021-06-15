import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/movies_api.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/search_movies.dart';

part 'movies_search_state.dart';

class MoviesSearchCubit extends Cubit<MoviesSearchState> {
  final SearchMovies searchMovies;

  MoviesSearchCubit({
    @required this.searchMovies,
  })  : assert(searchMovies != null),
        super(MoviesSearchInitial());

  Future<void> moviesSearchRestart() async {
    emit(MoviesSearchInitial());
  }

  Future<void> moviesSearch({
    String language = MoviesApi.es,
    String query,
  }) async {
    if (query.trim().isEmpty || query == null)
      emit(MoviesSearchInitial());
    else {
      emit(MoviesSearchLoadInProgress());

      // to avoid making a query in every on change
      Timer(
        Duration(milliseconds: 1500),
        () async {
          final failureOrMovies = await searchMovies(
            SearchMoviesParams(language: language, query: query),
          );

          failureOrMovies.fold(
            (failure) => emit(
              MoviesSearchLoadFailure(message: mapFailureToMessage(failure)),
            ),
            (movies) => emit(MoviesSearchLoadSuccess(movies: movies)),
          );
        },
      );
    }
  }
}
