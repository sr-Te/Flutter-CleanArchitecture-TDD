import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api/movies_api.dart';
import '../../../domain/entities/movie.dart';
import '../../genres/business_logic/genres_cubit.dart';
import '../ui/movie_poster.dart';
import 'movie_profile_appbar.dart';

class MoviesProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: MoviesProfileAppbar(title: movie.title),
      body: Stack(
        children: [
          MoviePoster(movie: movie),
          _infoCard(context, movie),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, Movie movie) {
    final topMargin = AppBar().preferredSize.height + 40;

    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top: topMargin, bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.4),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _moviePoster(context, movie),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _movieTitle(context, movie),
                        SizedBox(height: 10),
                        _rating(context, movie),
                        SizedBox(height: 10),
                        _movieGenres(context, movie),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _movieOverview(context, movie),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _moviePoster(BuildContext context, Movie movie) {
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
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          height: 170,
          width: 110,
          color: Colors.transparent,
          child: Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget _movieOverview(BuildContext context, Movie movie) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Sinopsis: '),
          SizedBox(height: 5),
          _getOverview(movie),
        ],
      ),
    );
  }

  Image randomCatImage() {
    List<String> catImages = [
      'cat1.jpeg',
      'cat2.jpeg',
      'cat3.jpeg',
      'cat4.jpeg'
    ];
    var rnd = new Random();
    int min = 0;
    int max = catImages.length - 1;
    int r = min + rnd.nextInt(max - min);
    String rndCatImage = catImages[r].toString();
    return Image.asset('assets/cats_img/' + rndCatImage, fit: BoxFit.cover);
  }

  Widget _getOverview(Movie movie) {
    if (movie.overview == null || movie.overview.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 130,
            height: 90,
            child: randomCatImage(),
          ),
          Text(
            'No hay sinopsis :c',
            textAlign: TextAlign.justify,
          ),
        ],
      );
    } else {
      return Text(
        movie.overview,
        textAlign: TextAlign.justify,
      );
    }
  }

  Widget _movieTitle(BuildContext context, Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Título Original:'),
        Center(
          child: Text(
            movie.originalTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _rating(BuildContext context, Movie movie) {
    return Row(
      children: [
        _sectionTitle('Valoración:'),
        SizedBox(width: 10),
        Text('${movie.voteAverage}/10'),
        Icon(Icons.star_border, size: 17),
      ],
    );
  }

  Widget _movieGenres(BuildContext context, Movie movie) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Géneros:'),
          BlocBuilder<GenresCubit, GenresState>(
            builder: (context, state) {
              if (state is GenresLoadSuccess) {
                return _getMoviesGenres(context, movie, state);
              } else if (state is GenresLoadInProgress) {
                return CircularProgressIndicator();
              } else {
                return Text('error al cargar los géneros :(, m3per d0nas¿');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _getMoviesGenres(
    BuildContext context,
    Movie movie,
    GenresLoadSuccess state,
  ) {
    String movieGenreNames = '';
    state.genres.forEach((genre) {
      movie.genreIds.forEach((movieGenreId) {
        if (genre.id == movieGenreId) {
          movieGenreNames += '${genre.name}, ';
        }
      });
    });

    movieGenreNames = movieGenreNames.substring(0, movieGenreNames.length - 2);
    movieGenreNames = movieGenreNames.trim();
    if (movieGenreNames.isNotEmpty)
      return Text(
        movieGenreNames,
        style: TextStyle(fontSize: 14),
      );
    else
      return Text(
        'No hay información, meperd0n as¿',
        style: TextStyle(fontSize: 14),
      );
  }
}
