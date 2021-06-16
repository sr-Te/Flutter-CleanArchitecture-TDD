import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_list/presentation/movies/business_logic/movies_nav_cubit/movies_nav_cubit.dart';

import 'drawer_button.dart';
import 'drawer_categories.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _drawerTitle('Ver Películas:'),
              _goToPopulars(context),
              _goToTopRated(context),
              _goToNowPlaying(context),
              _goToUpcoming(context),
              Divider(
                color: Colors.grey[900],
                height: 80,
              ),
              Row(
                children: [
                  _drawerTitle('Categorías'),
                  Expanded(child: Container()),
                  Icon(Icons.swap_vert),
                ],
              ),
              Expanded(child: DrawerCategories()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _goToNowPlaying(BuildContext context) {
    return DrawerButton(
      icon: Icons.play_circle_outline,
      title: 'En Reproducción',
      function: () {
        Navigator.of(context).pop();
        BlocProvider.of<MoviesNavCubit>(context).getMoviesNowPlaying();
      },
    );
  }

  _goToPopulars(BuildContext context) {
    return DrawerButton(
      icon: Icons.local_fire_department_outlined,
      title: 'Populares',
      function: () {
        Navigator.of(context).pop();
        BlocProvider.of<MoviesNavCubit>(context).getMoviesPopular();
      },
    );
  }

  _goToTopRated(BuildContext context) {
    return DrawerButton(
      icon: Icons.speed_outlined,
      title: 'Mejor Valoradas',
      function: () {
        Navigator.of(context).pop();
        BlocProvider.of<MoviesNavCubit>(context).getMoviesTopRated();
      },
    );
  }

  _goToUpcoming(BuildContext context) {
    return DrawerButton(
      icon: Icons.alarm_outlined,
      title: 'Próximamente',
      function: () {
        Navigator.of(context).pop();
        BlocProvider.of<MoviesNavCubit>(context).getMoviesUpcoming();
      },
    );
  }
}
