import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
