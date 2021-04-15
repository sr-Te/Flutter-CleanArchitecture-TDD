import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/globals/movies_api.dart';
import '../../../data/models/movie_model.dart';
import '../../widgets/transparent_appbar.dart';
import 'movie_poster.dart';
import 'movie_rating.dart';

class MovieProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel movie = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: TransparentAppbar(title: movie.title),
      body: Stack(
        children: [
          MoviePoster(movie: movie),
          _infoCard(context, movie),
        ],
      ),
    );
  }

  Widget _moviePoster(BuildContext context, MovieModel movie) {
    return Hero(
      tag: movie.id,
      child: CachedNetworkImage(
        imageUrl: MoviesApi.getMoviePoster(movie.posterPath),
        imageBuilder: (context, imageProvider) => Container(
          height: 170,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget _infoCard(BuildContext context, MovieModel movie) {
    final topMargin = AppBar().preferredSize.height + 30;
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: 10, left: 10, right: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.4),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _moviePoster(context, movie),
              Expanded(
                child: Column(
                  children: [
                    _movieTitle(context, movie),
                    MovieRating(movie: movie),
                  ],
                ),
              ),
            ],
          ),
          _movieOverview(context, movie),
        ],
      ),
    );
  }

  Widget _movieOverview(BuildContext context, MovieModel movie) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _movieTitle(BuildContext context, MovieModel movie) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 10),
        child: Text(
          movie.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
