import 'dart:convert';

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

GenreModel genreModelFromJson(String str) =>
    GenreModel.fromJson(json.decode(str));

String genreModelToJson(GenreModel data) => json.encode(data.toJson());

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
