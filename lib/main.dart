import 'package:fitness_tracker/screens/splash_screen.dart';
import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 241, 90, 36);

var kColorScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
);

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
        ),
        cardTheme: const CardTheme().copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: primaryColor,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 18,
              ),
            ),
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
