import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/api/movies_api.dart';
import '../../../../domain/entities/actor.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/production_company.dart';
import '../../genres/business_logic/genres_cubit.dart';
import '../business_logic/movie_cast_cubit/movie_cast_cubit.dart';
import '../business_logic/movie_details_cubit/movie_details_cubit.dart';
import '../movies_widgets/movie_poster.dart';
import 'movie_profile_appbar.dart';

const String CAT_ASSETS = 'assets/cats_img/';

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
            SizedBox(height: 10),
            _movieDetail(context, movie),
            SizedBox(height: 10),
            _movieCast(context, movie),
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
        errorWidget: (context, url, error) => Container(
          height: 170,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/img/no-image.jpg'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _movieOverview(BuildContext context, Movie movie) {
    String overview = AppLocalizations.of(context).movie_profile_overview;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('$overview: '),
          SizedBox(height: 5),
          _getOverview(context, movie),
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
    return Image.asset(CAT_ASSETS + rndCatImage, fit: BoxFit.cover);
  }

  Widget _getOverview(BuildContext context, Movie movie) {
    String noInfo = AppLocalizations.of(context).no_info;

    if (movie.overview == null || movie.overview.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 130,
            height: 90,
            child: randomCatImage(),
          ),
          Text(noInfo),
        ],
      );
    } else {
      return Text(movie.overview, textAlign: TextAlign.justify);
    }
  }

  Widget _movieTitle(BuildContext context, Movie movie) {
    String originalTitle =
        AppLocalizations.of(context).movie_profile_original_title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('$originalTitle: '),
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
    String score = AppLocalizations.of(context).movie_profile_assessment;

    return Row(
      children: [
        _sectionTitle('$score: '),
        SizedBox(width: 10),
        Text('${movie.voteAverage}/10'),
        Icon(Icons.star_border, size: 17),
      ],
    );
  }

  Widget _movieGenres(BuildContext context, Movie movie) {
    String genres = AppLocalizations.of(context).movie_profile_genres;
    String noInfo = AppLocalizations.of(context).no_info;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('$genres: '),
          BlocBuilder<GenresCubit, GenresState>(
            builder: (context, state) {
              if (state is GenresLoadSuccess) {
                return _getMoviesGenres(context, movie, state);
              } else if (state is GenresLoadInProgress) {
                return CircularProgressIndicator();
              } else {
                return Text(noInfo);
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
    String noInfo = AppLocalizations.of(context).no_info;
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
      return Text(noInfo);
  }

  Widget _movieDetail(BuildContext context, Movie movie) {
    String noInfo = AppLocalizations.of(context).no_info;

    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoadInProgress) {
          return CircularProgressIndicator();
        } else if (state is MovieDetailsLoadSuccess) {
          return _movieDetailsSuccessfulLoaded(context, state);
        } else if (state is MovieDetailsLoadFailure) {
          return Text(state.message);
        } else
          return Text(noInfo);
      },
    );
  }

  Widget _movieDetailsSuccessfulLoaded(
    BuildContext context,
    MovieDetailsLoadSuccess state,
  ) {
    String releaseDateL10n =
        AppLocalizations.of(context).movie_profile_release_date;
    String budget = AppLocalizations.of(context).movie_profile_budget;
    String revenue = AppLocalizations.of(context).movie_profile_revenue;
    String productionCompanies =
        AppLocalizations.of(context).movie_profile_production_compenies;
    String noInfo = AppLocalizations.of(context).no_info;

    final String releaseDate = state.movie.releaseDate != null
        ? '${state.movie.releaseDate.day}' +
            '-' +
            '${state.movie.releaseDate.month}' +
            '-' +
            '${state.movie.releaseDate.year}'
        : noInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('$releaseDateL10n: '),
        Text(releaseDate),
        SizedBox(height: 10),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('$budget: '),
                state.movie.budget != 0
                    ? Text(formatNumber(state.movie.budget))
                    : Text(noInfo),
              ],
            ),
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('$revenue: '),
                state.movie.revenue != 0
                    ? Text(formatNumber(state.movie.revenue))
                    : Text(noInfo),
              ],
            )
          ],
        ),
        SizedBox(height: 20),
        _sectionTitle('$productionCompanies: '),
        SizedBox(height: 10),
        _productionCompanies(context, state.movie.productionCompanies),
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

  Widget _productionCompanies(
    BuildContext context,
    List<ProductionCompany> companies,
  ) {
    String noInfo = AppLocalizations.of(context).no_info;

    if (companies.isNotEmpty)
      return SizedBox(
        height: 85.0,
        child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.4, initialPage: 1),
          itemCount: companies.length,
          itemBuilder: (context, i) => _companyLogo(companies[i]),
        ),
      );
    else
      return Text(noInfo);
  }

  Widget _companyLogo(ProductionCompany company) {
    return Container(
      padding: EdgeInsets.only(left: 20),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(company.name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _movieCast(BuildContext context, Movie movie) {
    String cast = AppLocalizations.of(context).movie_profile_cast;
    String noInfo = AppLocalizations.of(context).no_info;

    return BlocBuilder<MovieCastCubit, MovieCastState>(
      builder: (context, state) {
        if (state is MovieCastLoadSuccess) {
          if (state.cast.isNotEmpty)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('$cast: '),
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
                _sectionTitle('$cast: '),
                SizedBox(height: 10),
                Text(noInfo),
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
              _sectionTitle('$cast: '),
              SizedBox(height: 10),
              Text(noInfo),
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
