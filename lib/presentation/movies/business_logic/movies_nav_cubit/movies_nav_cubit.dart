import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

part 'movies_nav_state.dart';

class MoviesNavCubit extends Cubit<MoviesNavState> {
  MoviesNavCubit() : super(MoviesNavInitial());

  void getWithGenres(Genre genre) => emit(MoviesNavWithGenres(genre));
}
