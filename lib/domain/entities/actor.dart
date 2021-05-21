class Actor {
  int castId;
  String character;
  String creditId;
  String knownForDepartment;
  int id;
  String name;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.knownForDepartment,
    this.id,
    this.name,
    this.profilePath,
  });

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
