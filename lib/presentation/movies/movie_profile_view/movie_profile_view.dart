import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/api/movies_api.dart';
import '../../../../domain/entities/actor.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/production_company.dart';
import '../../genres/business_logic/genres_cubit.dart';
import '../business_logic/movie_cast_cubit/movie_cast_cubit.dart';
import '../business_logic/movie_details_cubit/movie_details_cubit.dart';
import '../movies_widgets/movie_poster.dart';
import 'movie_profile_appbar.dart';

const String NO_INFO = 'No hay información';

class MovieProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    BlocProvider.of<MovieDetailsCubit>(context)
        .movieDetailsGet(language: MoviesApi.es, movieId: movie.id);

    BlocProvider.of<MovieCastCubit>(context)
        .movieCastGet(language: MoviesApi.es, movieId: movie.id);

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
    final topMargin = AppBar().preferredSize.height + 50;

    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top: topMargin, bottom: 40, left: 20, right: 20),
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
                        _movieTitle(movie),
                        SizedBox(height: 10),
                        _rating(context, movie),
                        SizedBox(height: 10),
                        _movieGenres(movie),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _movieOverview(movie),
            SizedBox(height: 10),
            _movieDetail(movie),
            SizedBox(height: 10),
            _movieCast(movie),
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

  Widget _movieOverview(Movie movie) {
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
          Text('No hay sinopsis :(')
        ],
      );
    } else {
      return Text(movie.overview, textAlign: TextAlign.justify);
    }
  }

  Widget _movieTitle(Movie movie) {
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

  Widget _movieGenres(Movie movie) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Géneros:'),
          BlocBuilder<GenresCubit, GenresState>(
            builder: (context, state) {
              if (state is GenresLoadSuccess) {
                return _getMoviesGenres(movie, state);
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

    if (movieGenreNames.isNotEmpty) {
      movieGenreNames =
          movieGenreNames.substring(0, movieGenreNames.length - 2);
      movieGenreNames = movieGenreNames.trim();
      return Text(movieGenreNames);
    } else
      return Text('No hay informaciión, meperd0n as¿');
  }

  Widget _movieDetail(Movie movie) {
    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoadInProgress) {
          return CircularProgressIndicator();
        } else if (state is MovieDetailsLoadSuccess) {
          return _movieDetailsSuccessfulLoaded(state);
        } else if (state is MovieDetailsLoadFailure) {
          return Text(state.message);
        } else
          return Text('No hay detalles de esta película, meperd0n as¿');
      },
    );
  }

  Widget _movieDetailsSuccessfulLoaded(MovieDetailsLoadSuccess state) {
    final String releaseDate = state.movie.releaseDate != null
        ? '${state.movie.releaseDate.day}' +
            '-' +
            '${state.movie.releaseDate.month}' +
            '-' +
            '${state.movie.releaseDate.year}'
        : NO_INFO;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Fecha de lanzamiento: '),
        Text(releaseDate),
        SizedBox(height: 10),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Presupuesto: '),
                state.movie.budget != 0
                    ? Text(formatNumber(state.movie.budget))
                    : Text(NO_INFO),
              ],
            ),
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Ingresos: '),
                state.movie.revenue != 0
                    ? Text(formatNumber(state.movie.revenue))
                    : Text(NO_INFO),
              ],
            )
          ],
        ),
        SizedBox(height: 20),
        _sectionTitle('Compañias de producción: '),
        SizedBox(height: 10),
        _productionCompanies(state.movie.productionCompanies),
      ],
    );
  }

  String formatNumber(dynamic number) {
    var f = NumberFormat.simpleCurrency(
      name: '\$ ',
      decimalDigits: 0,
      locale: 'eu',
    );
    return '${f.format(number)}';
  }

  Widget _productionCompanies(List<ProductionCompany> companies) {
    if (companies.isNotEmpty)
      return SizedBox(
        height: 75.0,
        child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.4, initialPage: 1),
          itemCount: companies.length,
          itemBuilder: (context, i) => _companyLogo(companies[i]),
        ),
      );
    else
      return Text('No hay información al respecto');
  }

  Widget _companyLogo(ProductionCompany company) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: CachedNetworkImage(
        imageUrl: MoviesApi.getMoviePoster(company.logoPath),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(company.name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _movieCast(Movie movie) {
    return BlocBuilder<MovieCastCubit, MovieCastState>(
      builder: (context, state) {
        if (state is MovieCastLoadSuccess) {
          if (state.cast.isNotEmpty)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Reparto:'),
                SizedBox(height: 10),
                SizedBox(
                  height: 150.0,
                  child: PageView.builder(
                    pageSnapping: false,
                    controller:
                        PageController(viewportFraction: 0.35, initialPage: 1),
                    itemCount: state.cast.length,
                    itemBuilder: (context, i) => _actorCard(
                      context,
                      state.cast[i],
                    ),
                  ),
                ),
              ],
            );
          else
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Reparto:'),
                SizedBox(height: 10),
                Text('No hay detalles de esta película, meperd0n as¿'),
              ],
            );
        } else if (state is MovieCastLoadInProgress)
          return Container();
        else if (state is MovieCastLoadFailure)
          return Text(state.message);
        else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Reparto:'),
              SizedBox(height: 10),
              Text('No hay detalles de esta película, meperd0n as¿'),
            ],
          );
      },
    );
  }

  Widget _actorCard(BuildContext context, Actor actor) {
    return GestureDetector(
      onTap: () => _goToActorProfile(context, actor),
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: Stack(
          children: [
            Hero(
              tag: actor.id,
              child: Container(
                child: _actorPhoto(actor),
              ),
            ),
            Column(
              children: [
                Expanded(child: Container()),
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        actor.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actorPhoto(Actor actor) {
    return CachedNetworkImage(
      imageUrl: actor.getFoto(),
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

  _goToActorProfile(BuildContext context, Actor actor) {}
}
