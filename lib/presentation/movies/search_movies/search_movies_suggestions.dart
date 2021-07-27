import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../business_logic/movies_search_cubit/movies_search_cubit.dart';
import 'search_movies_success.dart';

class SearchMoviesSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: BlocBuilder<MoviesSearchCubit, MoviesSearchState>(
        builder: (context, state) {
          if (state is MoviesSearchLoadSuccess)
            return SearchMoviesSuccess(state.movies);
          else if (state is MoviesSearchLoadInProgress)
            return _loadingBuilder();
          else if (state is MoviesSearchLoadFailure)
            return _errorBuilder(context);
          else if (state is MoviesSearchInitial)
            return Container();
          else
            return null;
        },
      ),
    );
  }

  Widget _loadingBuilder() {
    return Row(
      children: [
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Widget _errorBuilder(BuildContext context) {
    String error = AppLocalizations.of(context).search_movies_error;

    return Text(
      'Parece que ha habido un error, intente otra vez!',
      style: TextStyle(fontSize: 15),
    );
  }
}
