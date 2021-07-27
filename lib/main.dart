import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routes.dart';
import 'injection_container.dart' as di;
import 'l10n/I10n.dart';
import 'presentation/genres/business_logic/genres_cubit.dart';
import 'presentation/movies/business_logic/movies_bloc/movies_bloc.dart';
import 'presentation/movies/business_logic/movies_search_cubit/movies_search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<GenresCubit>()),
        BlocProvider(create: (context) => di.sl<MoviesBloc>()),
        BlocProvider(create: (context) => di.sl<MoviesSearchCubit>()),
      ],
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black,
        ),
        onGenerateRoute: _router.onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
