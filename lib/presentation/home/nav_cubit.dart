import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void getMoviesTopRated() => emit(0);
  void getMoviesPopular() => emit(1);
  void getMoviesNowPlaying() => emit(2);
  void getMoviesUpcoming() => emit(3);
}
