import '../../data/models/production_company_model.dart';
import '../../data/models/production_country_model.dart';
import 'genre.dart';

class Movie {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  List<Genre> genres;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  int budget;
  int revenue;
  String homepage;
  List<ProductionCompanyModel> productionCompanies;
  List<ProductionCountryModel> productionCountries;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.genres,
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
    this.revenue,
    this.homepage,
    this.productionCompanies,
    this.productionCountries,
  });
}
