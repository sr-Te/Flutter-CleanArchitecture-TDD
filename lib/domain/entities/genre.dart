List<Genre> genreModelListFromJsonList(List<dynamic> jsonList) {
  if (jsonList == null) return [];

  List<Genre> genres = [];
  jsonList.forEach((item) {
    final genre = Genre.fromJson(item);
    genres.add(genre);
  });
  return genres;
}

List<Map<String, dynamic>> genreModelListToJsonList(List<Genre> genres) {
  List<Map<String, dynamic>> genresJson = [];
  genres.forEach((genre) {
    genresJson.add(genre.toJson());
  });
  return genresJson;
}

List<Map<String, dynamic>> genreListToJsonList(List<Genre> genres) {
  List<Map<String, dynamic>> genresJson = [];
  genres.forEach((genre) {
    genresJson.add(genreToJson(genre));
  });
  return genresJson;
}

Map<String, dynamic> genreToJson(Genre genre) =>
    {"id": genre.id, "name": genre.name};

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
