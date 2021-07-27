import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

part 'drawer_nav_state.dart';

class DrawerNavCubit extends Cubit<DrawerNavState> {
  DrawerNavCubit() : super(DrawerNavInitial());

  void getWithGenre(Genre genre) => emit(DrawerNavGenre(genre));
}
