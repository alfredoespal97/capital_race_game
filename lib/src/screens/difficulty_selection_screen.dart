
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capital_race/src/models/bot_profile.dart';
import 'package:capital_race/src/screens/game_screen.dart'; // Importaremos la pantalla de juego

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Dificultad', style: GoogleFonts.oswald()),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDifficultyButton(
              context,
              'Fácil',
              'El bot es conservador y tomará pocos riesgos.',
              const ConservativeBotProfile(),
            ),
            const SizedBox(height: 30),
            _buildDifficultyButton(
              context,
              'Medio',
              'El bot juega de forma equilibrada, buscando buenas oportunidades.',
              const BalancedBotProfile(),
            ),
            const SizedBox(height: 30),
            _buildDifficultyButton(
              context,
              'Difícil',
              'El bot es agresivo, buscará comprar y monopolizar a toda costa.',
              const AggressiveBotProfile(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String title, String subtitle, BotProfile profile) {
    return ElevatedButton(
      onPressed: () {
        // Navegamos a la pantalla del juego, pasando el perfil seleccionado como argumento
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreenWrapper(botProfile: profile),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Column(
        children: [
          Text(title, style: GoogleFonts.robotoCondensed(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 14)),
        ],
      ),
    );
  }
}
