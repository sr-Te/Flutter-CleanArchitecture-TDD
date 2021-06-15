import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../movies/business_logic/movies_search_cubit/movies_search_cubit.dart';
import '../../movies/search_movies/search_movies_bar.dart';
import 'business_logic/appbar_search_mode_cubit.dart';
import 'movie_view_mode_icon_button.dart';

class MainAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final GlobalKey<ScaffoldState> drawerKey;
  final String title;

  MainAppbar({
    @required this.title,
    this.drawerKey,
  })  : preferredSize = Size.fromHeight(80.0),
        super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppbarSearhModeCubit, bool>(
      builder: (context, state) {
        if (state)
          return AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            flexibleSpace: SafeArea(child: Center(child: SearchMoviesBar())),
            actions: [
              IconButton(
                icon: Icon(Icons.search_off),
                onPressed: () {
                  BlocProvider.of<MoviesSearchCubit>(context)
                      .moviesSearchRestart();
                  BlocProvider.of<AppbarSearhModeCubit>(context)
                      .appbarModeNormal();
                },
              ),
            ],
          );
        else
          return AppBar(
            title: Center(
              child: Container(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            actions: [
              MovieViewModeIconButton(),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => BlocProvider.of<AppbarSearhModeCubit>(context)
                    .appbarModeSearch(),
              ),
            ],
          );
      },
    );
  }
}
