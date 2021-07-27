import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/domain/entities/genre.dart';
import 'package:my_movie_list/presentation/custom_drawer/business_logic/drawer_nav_cubit/drawer_nav_cubit.dart';

void main() {
  DrawerNavCubit cubit;

  setUp(() {
    cubit = DrawerNavCubit();
  });

  final tGenre = Genre(id: 28, name: "Action");

  test(
    'initState should be DrawerNavPopular',
    () {
      // assert
      expect(cubit.state, equals(DrawerNavInitial()));
    },
  );

  test(
    'should emit DrawerNavWithGenres when requested',
    () {
      // assert layer
      final expected = [DrawerNavGenre(tGenre)];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getWithGenre(tGenre);
    },
  );
}
