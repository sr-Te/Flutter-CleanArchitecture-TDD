import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie_list/l10n/I10n.dart';
import '../business_logic/movies_search_cubit/movies_search_cubit.dart';

class SearchMoviesBar extends StatelessWidget {
  final double radius = 30;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String language = L10n.getLang[AppLocalizations.of(context).localeName];
    String searching = AppLocalizations.of(context).search_movies_searching;

    return Opacity(
      opacity: 0.7,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: TextField(
          onChanged: (query) => BlocProvider.of<MoviesSearchCubit>(context)
              .moviesSearch(query: query, language: language),
          autofocus: true,
          cursorColor: Colors.white,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            suffixIconConstraints: BoxConstraints(minWidth: 70),
            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
            hintText: searching,
            suffixIcon: _iconClearButton(context),
            focusedBorder: _outlineInputBorder(radius, Colors.white),
            enabledBorder: _outlineInputBorder(radius, Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _iconClearButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear, color: Colors.white),
      onPressed: () {
        controller.clear();
        BlocProvider.of<MoviesSearchCubit>(context).moviesSearchRestart();
      },
    );
  }

  OutlineInputBorder _outlineInputBorder(double radius, Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
