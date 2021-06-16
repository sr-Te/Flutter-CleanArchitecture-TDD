import 'package:flutter_bloc/flutter_bloc.dart';

class AppbarSearhModeCubit extends Cubit<bool> {
  AppbarSearhModeCubit() : super(false);

  void appbarModeSearch() {
    emit(true);
  }

  void appbarModeNormal() {
    emit(false);
  }
}
