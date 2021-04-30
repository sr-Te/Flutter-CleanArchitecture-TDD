import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/movies/bloc/movies_bloc.dart';
import '../presentation/movies/cubit/movies_nav_cubit.dart';
import '../presentation/movies/cubit/movies_view_mode_cubit/movies_view_mode_cubit.dart';
import '../presentation/movies/movies_home/movies_home.dart';
import '../presentation/movies/movies_profile/movie_profile_view.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
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
