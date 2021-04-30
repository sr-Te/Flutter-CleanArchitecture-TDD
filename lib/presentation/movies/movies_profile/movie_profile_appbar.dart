import 'package:flutter/material.dart';

class MoviesProfileAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final GlobalKey<ScaffoldState> drawerKey;
  final String title;

  MoviesProfileAppbar({
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
    );
  }
}
