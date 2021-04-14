import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_movie_list/presentation/widgets/custom_drawer.dart';

import '../../core/globals/movies_api.dart';
import 'bloc/movies_bloc.dart';
import 'ui/movies_swiper.dart';

class MoviesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Center(
          child: Container(
            child: Text(
              'Películas en reproducción',
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: CustomDrawer(),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is EmptyMovies)
            return _emptyMovies(context, state);
          else if (state is LoadedMovies)
            return _loadedMovies(context, state);
          else if (state is ErrorMovies)
            return _errorMovies(context, state);
          else
            return _loadingMovies(context, state);
        },
      ),
    );
  }

  Widget _emptyMovies(BuildContext context, EmptyMovies state) {
    BlocProvider.of<MoviesBloc>(context).add(GetNowPlaying(MoviesApi.es));
    return Center(child: Text('Intenta recargar la vista!'));
  }

  Widget _loadingMovies(BuildContext context, MoviesState state) {
    return CircularProgressIndicator();
  }

  Widget _loadedMovies(BuildContext context, LoadedMovies state) {
    return MoviesSwiper(movieList: state.movieList.items);
  }

  Widget _errorMovies(BuildContext context, ErrorMovies state) {
    return Center(child: Text(state.message));
  }
}
