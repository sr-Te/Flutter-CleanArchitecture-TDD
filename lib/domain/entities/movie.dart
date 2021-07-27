import 'production_company.dart';
import 'production_country.dart';

List<Movie> movieModelListFromJsonList(List<dynamic> jsonList) {
  if (jsonList == null) return [];

  List<Movie> movies = [];
  jsonList.forEach((item) {
    final movie = Movie.fromJson(item);
    movies.add(movie);
  });
  return movies;
}

List<Map<String, dynamic>> movieModelListToJsonList(List<Movie> movies) {
  List<Map<String, dynamic>> moviesJson = [];
  movies.forEach((movie) {
    moviesJson.add(movie.toJson());
  });
  return moviesJson;
}

class Movie {
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
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;

  Movie({
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
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
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
            ? List<ProductionCompany>.from(json["production_companies"]
                .map((x) => ProductionCompany.fromJson(x)))
            : [],
        productionCountries: json["production_countries"] != null
            ? List<ProductionCountry>.from(json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x)))
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
