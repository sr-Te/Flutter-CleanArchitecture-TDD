import 'package:flutter/material.dart';
import 'package:my_movie_list/data/models/movie_model.dart';

import 'ui/movie_profile.dart';

class MovieProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel movie = ModalRoute.of(context).settings.arguments;
    return MovieProfile(movie: movie);
  }
}
