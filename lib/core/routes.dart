import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/custom_drawer/business_logic/drawer_nav_cubit/drawer_nav_cubit.dart';
import '../presentation/movies/business_logic/appbar_search_mode_cubit.dart';
import '../presentation/movies/business_logic/movie_cast_cubit/movie_cast_cubit.dart';
import '../presentation/movies/business_logic/movie_details_cubit/movie_details_cubit.dart';
import '../presentation/movies/movie_profile_view/movie_profile_view.dart';
import '../presentation/index.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<DrawerNavCubit>()),
              BlocProvider(create: (context) => sl<AppbarSearhModeCubit>()),
            ],
            child: Index(),
          ),
        );
      case '/movie_profile':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<MovieDetailsCubit>()),
              BlocProvider(create: (context) => sl<MovieCastCubit>()),
            ],
            child: MovieProfileView(),
          ),
        );
      default:
        return null;
    }
  }
}
