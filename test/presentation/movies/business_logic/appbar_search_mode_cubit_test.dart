import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/presentation/movies/business_logic/appbar_search_mode_cubit.dart';

void main() {
  AppbarSearhModeCubit cubit;

  setUp(() {
    cubit = AppbarSearhModeCubit();
  });

  test(
    'initState should be false',
    () {
      // assert
      expect(cubit.state, equals(false));
    },
  );

  test(
    'should emit true when appbarModeSearch requested',
    () {
      // assert layer
      final expected = [true];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.appbarModeSearch();
    },
  );

  test(
    'should emit true when appbarModeNormal requested',
    () {
      // assert layer
      final expected = [false];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.appbarModeNormal();
    },
  );
}
