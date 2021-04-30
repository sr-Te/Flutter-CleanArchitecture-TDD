import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../movies/cubit/movies_nav_cubit.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ver Películas: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _goToTopRated(context),
              _goToPopulars(context),
              _goToNowPlaying(context),
              _goToUpcoming(context),
            ],
          ),
        ),
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

class DrawerButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() function;
  const DrawerButton(
      {@required this.icon, @required this.title, @required this.function});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: function,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
