import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/movie_model.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../../widgets/main_appbar/main_appbar.dart';
import '../business_logic/movies_bloc/movies_bloc.dart';
import '../business_logic/movies_view_mode_cubit.dart';
import 'movies_by_one_view.dart';
import 'movies_grid_view.dart';
import 'movies_loading_view.dart';

class MoviesView extends StatelessWidget {
  final String title;
  final String endpoint;
  final String language;

  const MoviesView({this.title, this.endpoint, this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: MainAppbar(title: title),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(height: 30, color: Colors.black),
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesLoadSuccess)
                  return _moviesLoadSuccess(state);
                else if (state is MoviesLoadFailure)
                  return _moviesFailure(context, state);
                else if (state is MoviesLoadInProgress)
                  return MoviesLoadingView();
                else
                  return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _moviesFailure(BuildContext context, MoviesLoadFailure state) {
    return Center(child: Text(state.message));
  }

  Widget _moviesLoadSuccess(MoviesLoadSuccess state) {
    List<MovieModel> movies = state.movies;

    return BlocBuilder<MoviesViewModeCubit, MoviesViewModeState>(
      builder: (context, state) {
        switch (state) {
          case MoviesViewModeState.oneByOne:
            return MoviesByOneView(movies: movies);
          case MoviesViewModeState.grid:
            return MoviesGridView(movies: movies);
          default:
            return null;
        }
      },
    );
  }
}
