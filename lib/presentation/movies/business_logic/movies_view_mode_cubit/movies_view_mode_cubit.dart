import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movies_view_mode_state.dart';

class MoviesViewModeCubit extends Cubit<MoviesViewModeState> {
  MoviesViewModeCubit() : super(MoviesViewByOneMode(index: 0));

  int actualIndex = 0;

  void byOneMovieViewMode({int index = 0}) {
    actualIndex = index;
    emit(MoviesViewByOneMode(index: actualIndex));
  }

  void gridMovieViewMode() {
    emit(MoviesViewGridMode());
  }
}
