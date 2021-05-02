import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/genres/business_logic/genres_cubit.dart';
import '../presentation/genres/genres_view/genres_grid_view.dart';
import '../presentation/movies/business_logic/movies_bloc/movies_bloc.dart';
import '../presentation/movies/business_logic/movies_nav_cubit.dart';
import '../presentation/movies/business_logic/movies_view_mode_cubit/movies_view_mode_cubit.dart';
import '../presentation/movies/movies_home.dart';
import '../presentation/movies/movies_profile/movie_profile_view.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => sl<GenresCubit>(), child: GenresGridView()),
        );
      case '/movies':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<MoviesNavCubit>()),
              BlocProvider(create: (context) => sl<MoviesBloc>()),
              BlocProvider(create: (context) => sl<MoviesViewModeCubit>()),
            ],
            child: MoviesHome(),
          ),
        );
      case '/movie_profile':
        return MaterialPageRoute(
            settings: settings, builder: (context) => MoviesProfileView());
      default:
        return null;
    }
  }
}
