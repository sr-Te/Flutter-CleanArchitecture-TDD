import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../movies/business_logic/movies_view_mode_cubit/movies_view_mode_cubit.dart';

class MovieViewModeIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesViewModeCubit, MoviesViewModeState>(
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
      },
    );
  }
}
