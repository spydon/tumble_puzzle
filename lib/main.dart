import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home.dart';

void main() {
  runApp(
    const ProviderScope(child: TumblePuzzle()),
  );
}

class TumblePuzzle extends StatelessWidget {
  const TumblePuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      textTheme: TextTheme(
        headline1: GoogleFonts.saira(
          fontSize: 21,
          color: Colors.white,
        ),
        button: GoogleFonts.saira(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyText2: GoogleFonts.saira(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          minimumSize: const Size(150, 50),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hoverColor: Colors.red.shade700,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.shade700,
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'TumblePuzzle',
      home: const Home(),
      theme: theme,
    );
  }
}
