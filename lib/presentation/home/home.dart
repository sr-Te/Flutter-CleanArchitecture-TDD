import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/globals/movies_api.dart';
import '../movies/bloc/movies_bloc.dart';
import '../movies/movies_view.dart';
import 'nav_cubit.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MoviesBloc, MoviesState>(
      listener: (context, state) {
        if (state is MoviesInitial) _initMovies(context, state);
      },
      child: BlocBuilder<NavCubit, int>(
        builder: (context, state) {
          switch (state) {
            case 1:
              return _moviesPopular(context);
            case 2:
              return _moviesNowPlaying(context);
            case 3:
              return _moviesUpcoming(context);
            default:
              return _moviesTopRated(context);
          }
        },
      ),
    );
  }

  Widget _moviesNowPlaying(BuildContext context) {
    String endpoint = MoviesEndpoint.nowPlaying;
    String language = MoviesApi.es;
    String title = 'En Reproducción';

    BlocProvider.of<MoviesBloc>(context).add(MoviesGet(endpoint, language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesPopular(BuildContext context) {
    String endpoint = MoviesEndpoint.popular;
    String language = MoviesApi.es;
    String title = 'Populares';

    BlocProvider.of<MoviesBloc>(context).add(MoviesGet(endpoint, language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesTopRated(BuildContext context) {
    String endpoint = MoviesEndpoint.topRated;
    String language = MoviesApi.es;
    String title = 'Mejor Valoradas';

    BlocProvider.of<MoviesBloc>(context).add(MoviesGet(endpoint, language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesUpcoming(BuildContext context) {
    String endpoint = MoviesEndpoint.upcoming;
    String language = MoviesApi.es;
    String title = 'Próximamente';

    BlocProvider.of<MoviesBloc>(context).add(MoviesGet(endpoint, language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  void _initMovies(BuildContext context, MoviesInitial state) {
    BlocProvider.of<MoviesBloc>(context).add(
      MoviesGet(MoviesEndpoint.topRated, MoviesApi.es),
    );
  }
}
