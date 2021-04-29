import 'package:flutter/material.dart';

import '../../domain/entities/genre.dart';

class GenreModel extends Genre {
  GenreModel({
    @required int id,
    @required String name,
  }) : super(id: id, name: name);
}
