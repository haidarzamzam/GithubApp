import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:github_app/app.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/screens/home_screen.dart';
import 'package:github_app/utils/end_point.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App.configure(apiBaseURL: Endpoint.baseURL, appTitle: 'Github App');

  await App().init();
  Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
              create: (BuildContext context) => SearchBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeScreen(),
        ));
  }
}
