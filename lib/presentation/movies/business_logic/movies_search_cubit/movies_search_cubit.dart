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

  Future<List<Movie>> moviesSearch({
    String language = MoviesApi.es,
    String query,
  }) async {
    emit(MoviesSearchLoadInProgress());
    List<Movie> movieList = [];

    final failureOrMovies = await searchMovies(
      Params(language: language, query: query),
    );

    failureOrMovies.fold(
      (failure) {
        emit(MoviesSearchLoadFailure(message: mapFailureToMessage(failure)));
        movieList = [];
        //return movieList;
      },
      (movies) {
        emit(MoviesSearchLoadSuccess(movies: movies));
        movieList = movies;
        //return movieList;
      },
    );

    return movieList;
  }
}
