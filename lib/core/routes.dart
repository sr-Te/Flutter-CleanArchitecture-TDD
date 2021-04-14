import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';
import '../presentation/home.dart';
import '../presentation/movies/bloc/movies_bloc.dart';
import '../presentation/movies/ui/movie_profile.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => sl<MoviesBloc>(),
                  child: Home(),
                ));
      case '/movie_profile':
        return MaterialPageRoute(
            settings: settings, builder: (context) => MovieProfile());
      default:
        return null;
    }
  }
}
