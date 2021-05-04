import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/presentation/genres/business_logic/genres_cubit.dart';

import '../../data/datasources/movies_api.dart';
import '../widgets/dialogs/on_will_pop_dialog.dart';
import 'business_logic/movies_bloc/movies_bloc.dart';
import 'business_logic/movies_nav_cubit.dart';
import 'movies_view/movies_view.dart';

class MoviesHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => OnWillPopDialog(),
      ),
      child: BlocBuilder<GenresCubit, GenresState>(builder: (context, state) {
        if (state is GenresInitial)
          BlocProvider.of<GenresCubit>(context)
              .genresGet(language: MoviesApi.es);
        return BlocBuilder<MoviesNavCubit, MovieCategory>(
          builder: (context, state) {
            switch (state) {
              case MovieCategory.topRated:
                return _moviesTopRated(context);
              case MovieCategory.nowPlaying:
                return _moviesNowPlaying(context);
              case MovieCategory.upComing:
                return _moviesUpcoming(context);
              case MovieCategory.popular:
                return _moviesPopular(context);
              default:
                return null;
            }
          },
        );
      }),
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

  void _initGenres(BuildContext context) {
    print('init genres');
    BlocProvider.of<GenresCubit>(context).genresGet(language: MoviesApi.es);
  }
}
