import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes.dart';
import 'injection_container.dart' as di;
import 'presentation/genres/business_logic/genres_cubit.dart';
import 'presentation/movies/business_logic/movies_bloc/movies_bloc.dart';

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
      ],
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
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
