import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/game_mode_screen.dart';
import 'screens/game_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const MonopolyApp());
}

class MonopolyApp extends StatelessWidget {
  const MonopolyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Monopoly Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B0000),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B0000),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        ),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/mode': (context) => const GameModeScreen(),
          '/game': (context) => const GameScreen(),
        },
      ),
    );
  }
}
