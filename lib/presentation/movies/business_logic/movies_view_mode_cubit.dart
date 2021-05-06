import 'package:flutter_bloc/flutter_bloc.dart';

enum MoviesViewModeState { oneByOne, grid }

class MoviesViewModeCubit extends Cubit<MoviesViewModeState> {
  MoviesViewModeCubit() : super(MoviesViewModeState.oneByOne);

  void byOneMovieViewMode() {
    print('cubit onebyone');
    emit(MoviesViewModeState.oneByOne);
  }

  void gridMovieViewMode() {
    print('cubit grid');
    emit(MoviesViewModeState.grid);
  }
}
