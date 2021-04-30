import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/presentation/movies/movies_view_mode_cubit/movies_view_mode_cubit.dart';

class TransparentAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final GlobalKey<ScaffoldState> drawerKey;
  final String title;

  TransparentAppbar({
    @required this.title,
    this.drawerKey,
  })  : preferredSize = Size.fromHeight(70.0),
        super();

  @override
  Widget build(BuildContext context) {
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
        BlocBuilder<MoviesViewModeCubit, MoviesViewModeState>(
            builder: (context, state) {
          if (state is MoviesViewGridMode)
            return IconButton(
              icon: Icon(Icons.style),
              onPressed: () => BlocProvider.of<MoviesViewModeCubit>(context)
                  .byOneMovieViewMode(),
            );
          else if (state is MoviesViewByOneMode)
            return IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () => BlocProvider.of<MoviesViewModeCubit>(context)
                  .gridMovieViewMode(),
            );
          else {
            return Container();
          }
        }),
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
      ],
    );
  }
}
