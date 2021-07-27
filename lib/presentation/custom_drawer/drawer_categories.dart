import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../genres/business_logic/genres_cubit.dart';
import 'business_logic/drawer_nav_cubit/drawer_nav_cubit.dart';
import 'drawer_category_button.dart';

class DrawerCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenresCubit, GenresState>(
      builder: (context, state) {
        if (state is GenresLoadSuccess)
          return ListView.builder(
            itemCount: state.genres.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 30),
                child: DrawerCategoryButton(
                  title: state.genres[index].name,
                  function: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<DrawerNavCubit>(context)
                        .getWithGenre(state.genres[index]);
                  },
                ),
              );
            },
          );
        else if (state is GenresLoadFailure)
          return Container(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(state.message),
          );
        else
          return Container(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircularProgressIndicator(),
                    Expanded(child: Container()),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          );
      },
    );
  }
}
