import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MoviesLoadingView extends StatefulWidget {
  @override
  _MoviesLoadingViewState createState() => _MoviesLoadingViewState();
}

class _MoviesLoadingViewState extends State<MoviesLoadingView> {
  Timer timer;
  double _width = 0;
  double _height = 0;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(milliseconds: 800), (Timer t) => _animateProperties());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Cargando Películas...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.all(50),
              child: AnimatedContainer(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: _borderRadius,
                ),
                duration: Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _animateProperties() {
    setState(() {
      final random = Random();

      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();

      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
    });
  }
}
