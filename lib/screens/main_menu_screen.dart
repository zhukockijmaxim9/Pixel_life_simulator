import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF121212),
              const Color(0xFF003366).withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title with shadow for "Pixel" look
            Stack(
              children: [
                Text(
                  'PIXEL PURSE',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 32,
                    color: Colors.cyanAccent.withValues(alpha: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    'PIXEL PURSE',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Симулятор жизни и финансов',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 80),
            // Play Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/job_select');
              },
              child: const Text('НАЧАТЬ ИГРУ'),
            ),
            const SizedBox(height: 20),
            // Shop Button (Secondary)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/shop');
              },
              child: Text(
                'МАГАЗИН МЕРЧА',
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Powered by Neoflex',
              style: TextStyle(fontSize: 10, color: Color(0xFF005EB8)),
            ),
          ],
        ),
      ),
    );
  }
}
