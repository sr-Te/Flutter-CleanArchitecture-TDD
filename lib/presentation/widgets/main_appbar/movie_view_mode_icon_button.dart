import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../movies/business_logic/movies_view_mode_cubit.dart';

class MovieViewModeIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesViewModeCubit, MoviesViewModeState>(
      builder: (context, state) {
        print(state);
        switch (state) {
          case MoviesViewModeState.oneByOne:
            return IconButton(
              icon: Icon(Icons.style),
              onPressed: () => BlocProvider.of<MoviesViewModeCubit>(context)
                  .gridMovieViewMode(),
            );
          case MoviesViewModeState.grid:
            return IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () => BlocProvider.of<MoviesViewModeCubit>(context)
                  .byOneMovieViewMode(),
            );
          default:
            return null;
        }
      },
    );
  }
}
