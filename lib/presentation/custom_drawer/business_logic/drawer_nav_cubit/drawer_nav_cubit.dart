import 'dart:developer' as logger;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

part 'drawer_nav_state.dart';

class DrawerNavCubit extends Cubit<DrawerNavState> {
  DrawerNavCubit() : super(DrawerNavInitial());

  @override
  void onChange(Change<DrawerNavState> change) {
    logger.log('3.1.2: genre => $change');
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    logger.log('3.1.3:  $error, $stackTrace');
    super.onError(error, stackTrace);
  }

  Future<void> getWithGenre(Genre genre) async {
    logger.log('3.1.1: genre => ${genre.name}');
    emit(DrawerNavGenre(genre));
  }
}
