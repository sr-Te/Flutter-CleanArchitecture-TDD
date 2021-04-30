import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_view_mode_cubit/movies_view_mode_cubit.dart';

void main() {
  MoviesViewModeCubit cubit;

  setUp(() {
    cubit = MoviesViewModeCubit();
  });

  test(
    'initState should be MoviesViewByOneMode with index 0',
    () {
      // assert
      expect(cubit.state, equals(MoviesViewByOneMode(index: 0)));
    },
  );
}
