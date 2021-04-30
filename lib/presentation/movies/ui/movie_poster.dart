import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/datasources/movies_api.dart';
import '../../../data/models/movie_model.dart';

class MoviePoster extends StatelessWidget {
  final MovieModel movie;

  const MoviePoster({this.movie});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: MoviesApi.getMoviePoster(movie.posterPath),
      imageBuilder: (context, imageProvider) => Opacity(
        opacity: 0.7,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(value: downloadProgress.progress),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
