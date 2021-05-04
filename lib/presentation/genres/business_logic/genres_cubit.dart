import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/api/movies_api.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/usecases/get_genres.dart';

part 'genres_state.dart';

class GenresCubit extends Cubit<GenresState> {
  final GetGenres getGenres;

  GenresCubit({
    @required this.getGenres,
  })  : assert(getGenres != null),
        super(GenresInitial());

  Future<void> genresGet({
    String language = MoviesApi.es,
  }) async {
    emit(GenresLoadInProgress());
    final failureOrGenres = await getGenres(Params(language: language));
    emit(
      failureOrGenres.fold(
        (failure) => GenresLoadFailure(message: _mapFailureToMessage(failure)),
        (genres) => GenresLoadSuccess(genres: genres),
      ),
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
