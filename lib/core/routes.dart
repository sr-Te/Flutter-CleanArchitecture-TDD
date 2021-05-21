import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/movies/business_logic/movies_nav_cubit/movies_nav_cubit.dart';
import '../presentation/movies/business_logic/movies_view_mode_cubit.dart';
import '../presentation/movies/movies_home.dart';
import '../presentation/movies/business_logic/movie_details_cubit/movie_details_cubit.dart';
import '../presentation/movies/movies_profile/movie_profile_view.dart';
import '../presentation/widgets/main_appbar/business_logic/appbar_search_mode_cubit.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<MoviesNavCubit>()),
              BlocProvider(create: (context) => sl<MoviesViewModeCubit>()),
              BlocProvider(create: (context) => sl<AppbarSearhModeCubit>()),
            ],
            child: MoviesHome(),
          ),
        );
      case '/movie_profile':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => sl<MovieDetailsCubit>(),
            child: MoviesProfileView(),
          ),
        );
      default:
        return null;
    }
  }
}
