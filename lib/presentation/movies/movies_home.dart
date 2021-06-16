import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/api/movies_api.dart';
import '../../core/api/movies_endpoint.dart';
import '../global_widgets/dialogs/on_will_pop_dialog.dart';
import 'business_logic/movies_bloc/movies_bloc.dart';
import 'business_logic/movies_nav_cubit/movies_nav_cubit.dart';
import 'movies_view/movies_view.dart';

class MoviesHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => OnWillPopDialog(),
      ),
      child: BlocBuilder<MoviesNavCubit, MoviesNavState>(
        builder: (context, state) {
          if (state is MoviesNavPopular)
            return _moviesPopular(context);
          else if (state is MoviesNavTopRated)
            return _moviesTopRated(context);
          else if (state is MoviesNavNowPlaying)
            return _moviesNowPlaying(context);
          else if (state is MoviesNavUpComing)
            return _moviesUpcoming(context);
          else if (state is MoviesNavWithGenres)
            return _moviesWithGenres(context, state);
          else
            return null;
        },
      ),
    );
  }

  Widget _moviesNowPlaying(BuildContext context) {
    String endpoint = MoviesEndpoint.nowPlaying;
    String language = MoviesApi.es;
    String title = 'En Reproducción';

    BlocProvider.of<MoviesBloc>(context)
        .add(MoviesGet(endpoint: endpoint, language: language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesPopular(BuildContext context) {
    String endpoint = MoviesEndpoint.popular;
    String language = MoviesApi.es;
    String title = 'Populares';

    BlocProvider.of<MoviesBloc>(context)
        .add(MoviesGet(endpoint: endpoint, language: language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesTopRated(BuildContext context) {
    String endpoint = MoviesEndpoint.topRated;
    String language = MoviesApi.es;
    String title = 'Mejor Valoradas';

    BlocProvider.of<MoviesBloc>(context)
        .add(MoviesGet(endpoint: endpoint, language: language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesUpcoming(BuildContext context) {
    String endpoint = MoviesEndpoint.upcoming;
    String language = MoviesApi.es;
    String title = 'Próximamente';

    BlocProvider.of<MoviesBloc>(context)
        .add(MoviesGet(endpoint: endpoint, language: language));
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _moviesWithGenres(BuildContext context, MoviesNavWithGenres state) {
    String endpoint = MoviesEndpoint.withGenre;
    String language = MoviesApi.es;
    String title = state.genre.name;

    BlocProvider.of<MoviesBloc>(context).add(
      MoviesGet(endpoint: endpoint, language: language, genre: state.genre.id),
    );
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }
}
