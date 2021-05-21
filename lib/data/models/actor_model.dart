import '../../domain/entities/actor.dart';

List<ActorModel> actorModelListFromJsonList(List<dynamic> jsonList) {
  if (jsonList == null) return [];

  List<ActorModel> cast = [];
  jsonList.forEach((item) {
    final actor = ActorModel.fromJson(item);
    cast.add(actor);
  });
  return cast;
}

class ActorModel extends Actor {
  ActorModel({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
  }) : super(
          id: id,
          name: name,
          profilePath: profilePath,
          character: character,
          castId: castId,
          creditId: creditId,
          knownForDepartment: knownForDepartment,
        );

  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;

  factory ActorModel.fromJson(Map<String, dynamic> json) => ActorModel(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
      };
}
