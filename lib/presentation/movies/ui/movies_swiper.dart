import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../core/globals/movies_api.dart';
import '../../../data/models/movie_model.dart';
import 'movie_poster.dart';
import 'movie_rating.dart';

class MoviesSwiper extends StatefulWidget {
  final List<MovieModel> movieList;
  const MoviesSwiper({this.movieList});

  @override
  _MoviesSwiperState createState() => _MoviesSwiperState();
}

class _MoviesSwiperState extends State<MoviesSwiper> {
  MovieModel actualMovie;

  @override
  void initState() {
    super.initState();
    actualMovie = widget.movieList[0];
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      MoviePoster(movie: actualMovie),
      Column(
        children: [
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: _movieTitle(context, actualMovie)),
              Expanded(flex: 1, child: MovieRating(movie: actualMovie)),
            ],
          ),
          SizedBox(height: 30),
          Container(
            height: _screenHeight * 0.54,
            child: Swiper(
              itemCount: widget.movieList.length,
              viewportFraction: 0.6,
              scale: 0.5,
              onIndexChanged: (i) => indexChange(i),
              itemBuilder: (context, i) =>
                  _moviePoster(context, widget.movieList[i]),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    ]);
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

  Widget _moviePoster(BuildContext context, MovieModel movie) {
    return Hero(
      tag: movie.id,
      child: GestureDetector(
        onTap: () => _goToMovieProfile(context, movie),
        child: CachedNetworkImage(
          imageUrl: MoviesApi.getMoviePoster(movie.posterPath),
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

  indexChange(int i) {
    actualMovie = widget.movieList[i];
    setState(() {});
  }

  _goToMovieProfile(BuildContext context, MovieModel movie) {
    Navigator.of(context).pushNamed('/movie_profile', arguments: movie);
  }
}
