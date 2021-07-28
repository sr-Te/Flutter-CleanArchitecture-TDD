import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

part 'drawer_nav_state.dart';

class DrawerNavCubit extends Cubit<DrawerNavState> {
  DrawerNavCubit() : super(DrawerNavInitial());

  @override
  void onChange(Change<DrawerNavState> change) {
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  Future<void> getWithGenre(Genre genre) async {
    emit(DrawerNavGenre(genre));
  }
}
