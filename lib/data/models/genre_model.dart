import '../../domain/entities/genre.dart';

List<GenreModel> genreModelListFromJsonList(List<dynamic> jsonList) {
  if (jsonList == null) return [];

  List<GenreModel> genres = [];
  jsonList.forEach((item) {
    final genre = GenreModel.fromJson(item);
    genres.add(genre);
  });
  return genres;
}

List<Map<String, dynamic>> genreModelListToJsonList(List<GenreModel> genres) {
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

class GenreModel extends Genre {
  GenreModel({
    this.id,
    this.name,
  }) : super(id: id, name: name);

  int id;
  String name;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
