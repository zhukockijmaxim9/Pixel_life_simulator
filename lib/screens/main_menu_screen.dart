import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final bool hasSave = state.selectedJob != null;
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
            // Play Buttons
            if (hasSave) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
                child: const Text('ПРОДОЛЖИТЬ ИГРУ'),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: Text(
                        'НОВАЯ ИГРА',
                        style: GoogleFonts.getFont('Press Start 2P', fontSize: 12, color: Colors.redAccent),
                      ),
                      content: Text(
                        'Вы уверены, что хотите начать заново? Текущий прогресс будет удален.',
                        style: GoogleFonts.getFont('Press Start 2P', fontSize: 8, color: Colors.white, height: 1.5),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('ОТМЕНА', style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            state.clearSaveAndReset();
                            Navigator.pushNamed(context, '/job_select');
                          },
                          child: Text('НАЧАТЬ', style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'НАЧАТЬ СНАЧАЛА',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ] else ...[
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
            ],
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
