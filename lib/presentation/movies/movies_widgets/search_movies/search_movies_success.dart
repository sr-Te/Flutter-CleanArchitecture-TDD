import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/movies_api.dart';
import '../../../../domain/entities/movie.dart';
import '../../business_logic/appbar_search_mode_cubit.dart';
import '../../business_logic/movies_search_cubit/movies_search_cubit.dart';

class SearchMoviesSuccess extends StatelessWidget {
  final List<Movie> movies;
  SearchMoviesSuccess(this.movies);

  @override
  Widget build(BuildContext context) {
    final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio,
    );

    if (movies.isNotEmpty)
      return Container(
        height: MediaQuery.of(context).size.height * 0.75 - viewInsets.bottom,
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: movies.length,
          itemBuilder: (context, i) => _movieTile(context, movies[i]),
        ),
      );
    else
      return _noItemsFound();
  }

  Widget _movieTile(BuildContext context, Movie movie) {
    return ListTile(
      onTap: () {
        BlocProvider.of<MoviesSearchCubit>(context).moviesSearchRestart();
        BlocProvider.of<AppbarSearhModeCubit>(context).appbarModeNormal();
        Navigator.of(context).pushNamed('/movie_profile', arguments: movie);
      },
      leading: _moviePoster(context, movie),
      title: Text(movie.title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(movie.originalTitle),
    );
  }

  Widget _moviePoster(BuildContext context, Movie movie) {
    return FadeInImage(
      image: NetworkImage(MoviesApi.getMoviePoster(movie.posterPath)),
      placeholder: AssetImage('assets/img/no-image.jpg'),
      width: 60.0,
      fit: BoxFit.contain,
    );
  }

  Widget _noItemsFound() {
    return BlocBuilder<MoviesSearchCubit, MoviesSearchState>(
        builder: (context, state) {
      if (state is MoviesSearchLoadFailure)
        return Text(
          state.message,
          style: TextStyle(fontSize: 15),
        );
      else
        return Text(
          'No se han encontrado películas que coincidan :(',
          style: TextStyle(fontSize: 15),
        );
    });
  }
}
