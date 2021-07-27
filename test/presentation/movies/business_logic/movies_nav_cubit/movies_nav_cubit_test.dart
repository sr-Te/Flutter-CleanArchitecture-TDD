import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/domain/entities/genre.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_nav_cubit/movies_nav_cubit.dart';

void main() {
  MoviesNavCubit cubit;

  setUp(() {
    cubit = MoviesNavCubit();
  });

  final tGenre = Genre(id: 28, name: "Action");

  test(
    'initState should be MoviesNavPopular',
    () {
      // assert
      expect(cubit.state, equals(MoviesNavInitial()));
    },
  );

  test(
    'should emit MoviesNavWithGenres when requested',
    () {
      // assert layer
      final expected = [MoviesNavWithGenres(tGenre)];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getWithGenres(tGenre);
    },
  );
}
