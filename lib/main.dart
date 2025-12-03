
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myapp/src/screens/home_screen.dart';
import 'package:myapp/src/screens/difficulty_selection_screen.dart';

// La referencia global se obtiene del nuevo archivo
export 'package:myapp/src/game_state.dart' show globalGameState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capital Race',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/difficulty': (context) => const DifficultySelectionScreen(),
      },
    );
  }
}
