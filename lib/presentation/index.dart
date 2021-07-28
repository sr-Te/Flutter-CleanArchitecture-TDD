import 'dart:developer' as logger;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/api/movies_endpoint.dart';
import '../domain/entities/genre.dart';
import '../l10n/I10n.dart';
import 'custom_drawer/business_logic/drawer_nav_cubit/drawer_nav_cubit.dart';
import 'genres/business_logic/genres_cubit.dart';
import 'genres/genres_view/genres_loading_view.dart';
import 'global_widgets/dialogs/on_will_pop_dialog.dart';
import 'movies/business_logic/movies_bloc/movies_bloc.dart';
import 'movies/movies_view/movies_view.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.log('1');
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => OnWillPopDialog(),
      ),
      child: BlocBuilder<GenresCubit, GenresState>(
        builder: (context, genresState) {
          if (genresState is GenresInitial) {
            _initGenres(context);
            return GenresLoadingView();
          } else if (genresState is GenresLoadInProgress) {
            return GenresLoadingView();
          } else if (genresState is GenresLoadFailure) {
            return _genresLoadFailure(context, genresState.message);
          } else if (genresState is GenresLoadSuccess) {
            return _genresLoadSuccess(context, genresState.genres);
            // return _moviesWithGenre(context, genresState.genres[0]);
          } else {
            return null;
          }
        },
      ),
    );
  }

  void _initGenres(BuildContext context) {
    logger.log('2');
    String language = L10n.getLang[AppLocalizations.of(context).localeName];
    BlocProvider.of<GenresCubit>(context).genresGet(language: language);
  }

  Widget _genresLoadSuccess(BuildContext context, List<Genre> genres) {
    logger.log('3');
    return BlocBuilder<DrawerNavCubit, DrawerNavState>(
      builder: (context, state) {
        logger.log('3.0.1: state => $state');
        if (state is DrawerNavInitial) {
          logger.log('3.1: genre => ${genres[0].name}');
          BlocProvider.of<DrawerNavCubit>(context).getWithGenre(genres[0]);
          return _moviesWithGenre(context, genres[0]);
        } else if (state is DrawerNavGenre) {
          logger.log('3.2');
          return _moviesWithGenre(context, state.genre);
        } else {
          return null;
        }
      },
    );
  }

  Widget _moviesWithGenre(BuildContext context, Genre genre) {
    logger.log('4');
    String endpoint = MoviesEndpoint.withGenre;
    String language = L10n.getLang[AppLocalizations.of(context).localeName];
    String title = genre.name;

    BlocProvider.of<MoviesBloc>(context).add(
      MoviesGet(endpoint: endpoint, language: language, genre: genre.id),
    );
    return MoviesView(title: title, endpoint: endpoint, language: language);
  }

  Widget _genresLoadFailure(BuildContext context, String message) {
    logger.log('5');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
      ),
    );
    return GenresLoadingView();
  }
}
