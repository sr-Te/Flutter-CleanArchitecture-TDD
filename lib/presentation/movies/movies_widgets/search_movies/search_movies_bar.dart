import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/movies_search_cubit/movies_search_cubit.dart';

class SearchMoviesBar extends StatelessWidget {
  final double radius = 30;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              .moviesSearch(query: query),
          autofocus: true,
          cursorColor: Colors.white,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            suffixIconConstraints: BoxConstraints(minWidth: 70),
            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
            hintText: 'Buscando películas...',
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
