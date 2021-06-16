import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../data/models/movie_model.dart';

class MovieRating extends StatelessWidget {
  final MovieModel movie;
  final bool tiny;

  const MovieRating({this.movie, this.tiny = false});
  @override
  Widget build(BuildContext context) {
    final _percent = movie.voteAverage / 10;
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: CircularPercentIndicator(
          radius: tiny ? 45 : 65.0,
          animation: true,
          animationDuration: 800,
          lineWidth: tiny ? 5.0 : 7.0,
          percent: _percent,
          center: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    padding: EdgeInsets.all(tiny ? 8.2 : 15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text('....'),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${movie.voteAverage}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: tiny ? 12 : 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.black.withOpacity(0.4),
          progressColor: movie.voteAverage >= 7
              ? Colors.green
              : movie.voteAverage >= 4
                  ? Colors.yellow
                  : Colors.red,
        ),
      ),
    );
  }
}
