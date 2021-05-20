import '../../data/models/production_company_model.dart';
import '../../data/models/production_country_model.dart';

class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  int budget;
  String homepage;
  List<ProductionCompanyModel> productionCompanies;
  List<ProductionCountryModel> productionCountries;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.budget,
    this.homepage,
    this.productionCompanies,
    this.productionCountries,
  });
}
