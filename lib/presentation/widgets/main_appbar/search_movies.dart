import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/network/api/movies_api.dart';
import '../../../domain/entities/movie.dart';
import 'business_logic/appbar_search_mode_cubit.dart';

class SearchMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double radius = 30;
    return Opacity(
      opacity: 0.7,
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: TypeAheadField(
          keepSuggestionsOnLoading: false,
          hideSuggestionsOnKeyboardHide: false,
          suggestionsBoxDecoration: _suggestionsBoxDecoration(),
          textFieldConfiguration: _texFieldConfiguration(context, radius),
          loadingBuilder: (context) => _loadingBuilder(),
          noItemsFoundBuilder: (context) => _noItemsFound(),
          errorBuilder: (context, exception) => _loadingBuilder(),
          suggestionsCallback: (pattern) async {
            return await MoviesApi.buscarPelicula(pattern);
          },
          itemBuilder: (context, Movie movieSuggestion) {
            return _listTile(context, movieSuggestion);
          },
          onSuggestionSelected: (movieSuggestion) => Navigator.of(context)
              .pushNamed('/movie_profile', arguments: movieSuggestion),
        ),
      ),
    );
  }

  _suggestionsBoxDecoration() {
    return SuggestionsBoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.grey[300],
      elevation: 10,
    );
  }

  _texFieldConfiguration(BuildContext context, double radius) {
    return TextFieldConfiguration(
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        suffixIconConstraints: BoxConstraints(minWidth: 70),
        hintStyle: TextStyle(color: Colors.white, fontSize: 13),
        hintText: 'Buscando películas...',
        suffixIcon: _iconClearButton(context),
        focusedBorder: _outlineInputBorder(radius, Colors.white),
        enabledBorder: _outlineInputBorder(radius, Colors.red),
      ),
    );
  }

  _iconClearButton(context) {
    return IconButton(
      icon: Icon(Icons.clear, color: Colors.white),
      onPressed: () =>
          BlocProvider.of<AppbarSearhModeCubit>(context).appbarModeNormal(),
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'No se han encontrado películas que coincidan :(',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  _loadingBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }
}
