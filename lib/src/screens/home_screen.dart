
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Capital Race',
              style: GoogleFonts.oswald(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(3, 3)),
                ]
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'El juego de estrategia económica',
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            _buildMenuButton(context, 'Jugar', () {
              Navigator.pushNamed(context, '/difficulty');
            }),
            const SizedBox(height: 20),
            _buildMenuButton(context, 'Tutorial', () {
              // Aún no implementado
            }, enabled: false),
            const SizedBox(height: 20),
            _buildMenuButton(context, 'Ajustes', () {
              // Aún no implementado
            }, enabled: false),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed, {bool enabled = true}) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        minimumSize: const Size(220, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
      child: Text(
        text,
        style: GoogleFonts.robotoCondensed(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
