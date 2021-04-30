import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/home/home.dart';
import '../presentation/home/nav_cubit.dart';
import '../presentation/movies/bloc/movies_bloc.dart';
import '../presentation/movies/movies_profile/movie_profile_view.dart';
import '../presentation/movies/movies_view_mode_cubit/movies_view_mode_cubit.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<NavCubit>()),
              BlocProvider(create: (context) => sl<MoviesBloc>()),
              BlocProvider(create: (context) => sl<MoviesViewModeCubit>()),
            ],
            child: Home(),
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
