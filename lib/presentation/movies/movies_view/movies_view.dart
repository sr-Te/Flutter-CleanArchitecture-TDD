import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global_widgets/custom_drawer/custom_drawer.dart';
import '../business_logic/appbar_search_mode_cubit.dart';
import '../business_logic/movies_bloc/movies_bloc.dart';
import '../business_logic/movies_search_cubit/movies_search_cubit.dart';
import '../movies_widgets/movies_appbar.dart';
import '../movies_widgets/search_movies/search_movies_suggestions.dart';
import 'movies_grid_view.dart';
import 'movies_loading_view.dart';

class MoviesView extends StatelessWidget {
  final String title;
  final String endpoint;
  final String language;

  const MoviesView({this.title, this.endpoint, this.language});

  @override
  Widget build(BuildContext context) {
    final mainAppbar = MoviesAppBar(title: title);
    final bodyMargin = 30.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: mainAppbar,
      drawer: CustomDrawer(),
      body: BlocBuilder<MoviesSearchCubit, MoviesSearchState>(
        builder: (context, searchState) {
          if (searchState is MoviesSearchInitial)
            return _viewMovies(bodyMargin);
          else
            return BlocBuilder<AppbarSearhModeCubit, bool>(
              builder: (context, inSearchMode) {
                if (inSearchMode)
                  return Stack(
                    children: [
                      _viewMovies(bodyMargin),
                      Column(
                        children: [
                          SizedBox(height: mainAppbar.preferredSize.height),
                          SizedBox(height: bodyMargin),
                          SizedBox(height: 10),
                          SearchMoviesSuggestions(),
                        ],
                      ),
                    ],
                  );
                else
                  return _viewMovies(bodyMargin);
              },
            );
        },
      ),
    );
  }

  Widget _viewMovies(double bodyMargin) {
    return Column(
      children: [
        Container(height: bodyMargin, color: Colors.black),
        Expanded(
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, state) {
              if (state is MoviesLoadSuccess)
                return MoviesGridView(movies: state.movies);
              else if (state is MoviesLoadFailure)
                return Center(child: Text(state.message));
              else if (state is MoviesLoadInProgress)
                return MoviesLoadingView();
              else
                return null;
            },
          ),
        ),
      ],
    );
  }
}
