import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_nav_cubit/movies_nav_cubit.dart';

import '../../../core/network/api/movies_api.dart';
import '../../../data/models/movie_model.dart';
import '../business_logic/movies_view_mode_cubit/movies_view_mode_cubit.dart';
import '../ui/movie_poster.dart';
import '../ui/movie_rating.dart';

class MoviesByOneView extends StatefulWidget {
  final List<MovieModel> movies;
  const MoviesByOneView({this.movies});

  @override
  _MoviesByOneViewState createState() => _MoviesByOneViewState();
}

class _MoviesByOneViewState extends State<MoviesByOneView> {
  int index;

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<MoviesNavCubit, MoviesNavState>(
      listener: (context, state) {
        index = 0;
        setState(() {});
      },
      child: BlocBuilder<MoviesViewModeCubit, MoviesViewModeState>(
          builder: (context, state) {
        if (state is MoviesViewByOneMode) {
          index = state.index;
        }
        return Stack(children: [
          MoviePoster(movie: widget.movies[index]),
          Column(
            children: [
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: _movieTitle(context, widget.movies[index]),
                  ),
                  Expanded(
                    flex: 1,
                    child: MovieRating(movie: widget.movies[index]),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: _screenHeight * 0.54,
                child: Swiper(
                  itemCount: widget.movies.length,
                  viewportFraction: 0.6,
                  scale: 0.5,
                  index: index,
                  onIndexChanged: (i) => indexChange(i),
                  itemBuilder: (context, i) => _moviePoster(context, i),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ]);
      }),
    );
  }

  indexChange(int i) {
    BlocProvider.of<MoviesViewModeCubit>(context).byOneMovieViewMode(index: i);
    index = i;
    setState(() {});
  }

  _goToMovieProfile(BuildContext context, MovieModel movie) {
    Navigator.of(context).pushNamed('/movie_profile', arguments: movie);
  }

  Widget _moviePoster(BuildContext context, int index) {
    return Hero(
      tag: widget.movies[index].id,
      child: GestureDetector(
        onTap: () => _goToMovieProfile(context, widget.movies[index]),
        child: CachedNetworkImage(
          imageUrl: MoviesApi.getMoviePoster(widget.movies[index].posterPath),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _movieTitle(BuildContext context, MovieModel actualMovie) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            actualMovie.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
