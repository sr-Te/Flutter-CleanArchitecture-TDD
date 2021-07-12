import '../../domain/entities/movie.dart';
import 'production_company_model.dart';
import 'production_country_model.dart';

List<MovieModel> movieModelListFromJsonList(List<dynamic> jsonList) {
  if (jsonList == null) return [];

  List<MovieModel> movies = [];
  jsonList.forEach((item) {
    final movie = MovieModel.fromJson(item);
    movies.add(movie);
  });
  return movies;
}

List<Map<String, dynamic>> movieModelListToJsonList(List<MovieModel> movies) {
  List<Map<String, dynamic>> moviesJson = [];
  movies.forEach((movie) {
    moviesJson.add(movie.toJson());
  });
  return moviesJson;
}

class MovieModel extends Movie {
  int id;
  String title;
  String homepage;
  bool adult;
  String backdropPath;
  List<int> genreIds;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  bool video;
  double voteAverage;
  int voteCount;
  int budget;
  int revenue;
  List<ProductionCompanyModel> productionCompanies;
  List<ProductionCountryModel> productionCountries;

  MovieModel({
    this.id,
    this.title,
    this.homepage,
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.budget,
    this.revenue,
    this.productionCompanies,
    this.productionCountries,
  }) : super(
          id: id,
          title: title,
          adult: adult,
          backdropPath: backdropPath,
          genreIds: genreIds,
          originalLanguage: originalLanguage,
          originalTitle: originalTitle,
          overview: overview,
          popularity: popularity,
          posterPath: posterPath,
          releaseDate: releaseDate,
          video: video,
          voteAverage: voteAverage,
          voteCount: voteCount,
          budget: budget,
          revenue: revenue,
          homepage: homepage,
          productionCompanies: productionCompanies,
          productionCountries: productionCountries,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] != null
            ? List<int>.from(json["genre_ids"].map((x) => x))
            : [],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] == ""
            ? null
            : DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        budget: json["budget"],
        revenue: json["revenue"],
        homepage: json["homepage"],
        productionCompanies: json["production_companies"] != null
            ? List<ProductionCompanyModel>.from(json["production_companies"]
                .map((x) => ProductionCompanyModel.fromJson(x)))
            : [],
        productionCountries: json["production_countries"] != null
            ? List<ProductionCountryModel>.from(json["production_countries"]
                .map((x) => ProductionCountryModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate == null
            ? null
            : "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "budget": budget,
        "homepage": homepage,
        "production_companies":
            List<dynamic>.from(productionCompanies.map((x) => x.toJson())),
        "production_countries":
            List<dynamic>.from(productionCountries.map((x) => x.toJson())),
      };
}
