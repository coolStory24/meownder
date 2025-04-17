import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/liked_cats_screen.dart';
import 'blocs/home/home_bloc.dart';
import 'data/repositories/cat_repository.dart';
import 'di.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => HomeBloc(getIt<CatRepository>())..add(FetchNewCat()),
        ),
      ],
      child: MaterialApp(
        title: 'Meownder',
        theme: ThemeData(
          primaryColor: Color(0xFFFE3C72),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFFE3C72),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFE3C72),
              foregroundColor: Colors.white,
            ),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
            headlineSmall: TextStyle(
              color: Colors.white,
              fontFamily: 'DancingScript',
              fontWeight: FontWeight.w700,
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFE3C72),
            secondary: Color(0xFFFF758C),
            surface: Colors.white,
          ),
        ),
        home: HomeScreen(),
        routes: {'/liked': (context) => LikedCatsScreen()},
      ),
    );
  }
}
