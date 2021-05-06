import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/network/api/movies_api.dart';
import '../../../domain/entities/movie.dart';
import '../../widgets/main_appbar/business_logic/appbar_search_mode_cubit.dart';
import '../business_logic/movies_search_cubit/movies_search_cubit.dart';

class SearchMoviesBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double radius = 30;
    var editingController = TextEditingController();
    var suggestionsBoxController = SuggestionsBoxController();

    return Opacity(
      opacity: 0.7,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: TypeAheadField(
              suggestionsBoxController: suggestionsBoxController,
              keepSuggestionsOnLoading: false,
              hideSuggestionsOnKeyboardHide: false,
              suggestionsBoxDecoration: _suggestionsBoxDecoration(context),
              textFieldConfiguration:
                  _texFieldConfiguration(context, radius, editingController),
              loadingBuilder: (context) => _loadingBuilder(),
              noItemsFoundBuilder: (context) => _noItemsFound(),
              errorBuilder: (context, exception) => _loadingBuilder(),
              suggestionsCallback: (pattern) async =>
                  await BlocProvider.of<MoviesSearchCubit>(context)
                      .moviesSearch(language: MoviesApi.es, query: pattern),
              itemBuilder: (context, Movie movieSuggestion) {
                return _listTile(context, movieSuggestion);
              },
              onSuggestionSelected: (movieSuggestion) {
                BlocProvider.of<AppbarSearhModeCubit>(context)
                    .appbarModeNormal();
                Navigator.of(context)
                    .pushNamed('/movie_profile', arguments: movieSuggestion);
              })),
    );
  }

  _suggestionsBoxDecoration(BuildContext context) {
    return SuggestionsBoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.grey[300],
      elevation: 10,
    );
  }

  _texFieldConfiguration(
      BuildContext context, double radius, TextEditingController controller) {
    return TextFieldConfiguration(
      autofocus: true,
      cursorColor: Colors.white,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        suffixIconConstraints: BoxConstraints(minWidth: 70),
        hintStyle: TextStyle(color: Colors.white, fontSize: 15),
        hintText: 'Buscando películas...',
        suffixIcon: _iconClearButton(context, controller),
        focusedBorder: _outlineInputBorder(radius, Colors.white),
        enabledBorder: _outlineInputBorder(radius, Colors.red),
      ),
    );
  }

  _iconClearButton(BuildContext context, TextEditingController controller) {
    return IconButton(
      icon: Icon(Icons.clear, color: Colors.white),
      onPressed: () {
        controller.clear();
        BlocProvider.of<MoviesSearchCubit>(context).moviesSearchRestart();
      },
    );
  }

  _outlineInputBorder(double radius, Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  Widget _listTile(BuildContext context, Movie movie) {
    return ListTile(
      leading: _moviePoster(context, movie),
      title: Text(movie.title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(movie.originalTitle),
    );
  }

  Widget _moviePoster(BuildContext context, Movie movie) {
    return FadeInImage(
      image: NetworkImage(MoviesApi.getMoviePoster(movie.posterPath)),
      placeholder: AssetImage('assets/img/no-image.jpg'),
      width: 60.0,
      fit: BoxFit.contain,
    );
  }

  _noItemsFound() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocBuilder<MoviesSearchCubit, MoviesSearchState>(
          builder: (context, state) {
        if (state is MoviesSearchLoadFailure)
          return Text(
            state.message,
            style: TextStyle(fontSize: 15),
          );
        else
          return Text(
            'No se han encontrado películas que coincidan :(',
            style: TextStyle(fontSize: 15),
          );
      }),
    );
  }

  _loadingBuilder() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.transparent,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }
}
