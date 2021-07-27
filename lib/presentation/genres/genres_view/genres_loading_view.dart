import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenresLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String loadingGenres = AppLocalizations.of(context).loading_genres;

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
                  loadingGenres,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
            Expanded(flex: 15, child: Container()),
          ],
        ),
      ),
    );
  }
}
