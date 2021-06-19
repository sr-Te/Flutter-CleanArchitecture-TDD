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
      expect(cubit.state, equals(MoviesNavPopular()));
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

  test(
    'should emit MoviesNavPopular when requested',
    () {
      // assert layer
      final expected = [MoviesNavPopular()];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getMoviesPopular();
    },
  );

  test(
    'should emit MoviesNavTopRated when requested',
    () {
      // assert layer
      final expected = [MoviesNavTopRated()];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getMoviesTopRated();
    },
  );

  test(
    'should emit MoviesNavUpComing when requested',
    () {
      // assert layer
      final expected = [MoviesNavUpComing()];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getMoviesUpcoming();
    },
  );

  test(
    'should emit MoviesNavNowPlaying when requested',
    () {
      // assert layer
      final expected = [MoviesNavNowPlaying()];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getMoviesNowPlaying();
    },
  );

  test(
    'should emit MoviesNavNowPlaying when requested',
    () {
      // assert layer
      final expected = [MoviesNavNowPlaying()];
      expectLater(cubit.stream, emitsInOrder(expected));
      //act
      cubit.getMoviesNowPlaying();
    },
  );
}
