import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/api/movies_api.dart';
import '../../../domain/entities/movie.dart';
import '../movies_widgets/movie_rating.dart';

class MoviesGridView extends StatelessWidget {
  final List<Movie> movies;

  const MoviesGridView({this.movies});
  @override
  Widget build(BuildContext context) {
    double padd = 20;
    return Column(
      children: [
        SizedBox(height: 90),
        Expanded(
          child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: padd),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 5 / 8,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieGridCard(movies[index]);
              }),
        ),
      ],
    );
  }
}

class MovieGridCard extends StatelessWidget {
  final Movie movie;
  MovieGridCard(this.movie);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToMovieProfile(context, movie),
      child: Stack(
        children: [
          Hero(
            tag: movie.id,
            child: Container(
              child: _posterImage(movie),
            ),
          ),
          _movieTitle(movie),
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                height: 170,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    MovieRating(movie: movie, tiny: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _posterImage(Movie movie) {
    return CachedNetworkImage(
      imageUrl: MoviesApi.getMoviePoster(movie.posterPath),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(value: downloadProgress.progress)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _movieTitle(Movie movie) {
    return Column(
      children: [
        Expanded(child: Container()),
        Container(
          height: 85,
          width: double.infinity,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _goToMovieProfile(BuildContext context, movie) {
    Navigator.of(context).pushNamed('/movie_profile', arguments: movie);
  }
}
