import 'package:flutter/material.dart';

class GenresLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 30, child: Container()),
            Expanded(
              flex: 15,
              child: Container(
                child: Text(
                  'Cargando Categorías...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Container(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Expanded(flex: 15, child: Container()),
          ],
        ),
      ),
    );
  }
}
