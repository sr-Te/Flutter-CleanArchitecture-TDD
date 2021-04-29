
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/transparent_appbar.dart';
import 'bloc/movies_bloc.dart';
import 'ui/movies_loading_view.dart';
import 'ui/movies_swiper.dart';

class MoviesView extends StatelessWidget {
  final String title;
  final String endpoint;
  final String language;

  const MoviesView({this.title, this.endpoint, this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: TransparentAppbar(title: title),
      drawer: CustomDrawer(),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadSuccess)
            return MoviesSwiper(movieList: state.movieList.items);
          else if (state is MoviesLoadFailure)
            return _moviesFailure(context, state);
          else
            return MoviesLoadingView();
        },
      ),
    );
  }

  Widget _moviesFailure(BuildContext context, MoviesLoadFailure state) {
    return Center(child: Text(state.message));
  }
}
