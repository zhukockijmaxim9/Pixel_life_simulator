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
            // Градиентный логотип PIXEL PURSE
            ShaderMask(
              shaderCallback: (bounds) {
                const gradient = LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.33, 0.58, 0.78, 1.0],
                  colors: [
                    Color(0xFF8F1162),
                    Color(0xFFC0045C),
                    Color(0xFFC5035C),
                    Color(0xFFE74B31),
                    Color(0xFFEB9B2A),
                  ],
                );
                return gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                );
              },
              child: Text(
                'PIXEL PURSE',
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 32,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
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
              _primaryButton(
                label: 'ПРОДОЛЖИТЬ ИГРУ',
                onPressed: () => Navigator.pushNamed(context, '/game'),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE74B31), width: 2),
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
                        style: GoogleFonts.getFont('Press Start 2P', fontSize: 12, color: Color(0xFFE74B31)),
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
                          child: Text('НАЧАТЬ', style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, color: Color(0xFFE74B31))),
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
                    color: const Color(0xFFE74B31),
                  ),
                ),
              ),
            ] else ...[
              _primaryButton(
                label: 'НАЧАТЬ ИГРУ',
                onPressed: () => Navigator.pushNamed(context, '/job_select'),
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
                  color: const Color(0xFFEB9B2A),
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Powered by Neoflex',
              style: TextStyle(fontSize: 10, color: Color(0xFFC0045C)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryGradientButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 56,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.33, 0.58, 0.78, 1.0],
            colors: [
              Color(0xFF8F1162),
              Color(0xFFC0045C),
              Color(0xFFC5035C),
              Color(0xFFE74B31),
              Color(0xFFEB9B2A),
            ],
          ),
          borderRadius: BorderRadius.zero,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _primaryButton({required String label, required VoidCallback onPressed}) {
  return _PrimaryGradientButton(label: label, onPressed: onPressed);
}
