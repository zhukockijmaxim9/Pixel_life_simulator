import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../ui_theme.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final bool hasSave = state.selectedJob != null;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Фон: градиент от серого к розовому
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.greyPinkGradient,
            ),
          ),
          // Слой с "искорками"-звёздами
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _SparklePainter(_controller.value),
                size: MediaQuery.of(context).size,
              );
            },
          ),
          // Основной контент по центру
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Логотип PIXEL PURSE с белым текстом и мерцающими звёздами рядом
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final phase = _controller.value;
                    final starOpacity =
                        0.4 + 0.6 * (0.5 + 0.5 * math.sin(2 * math.pi * phase));
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: starOpacity,
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PIXEL PURSE',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 32,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Opacity(
                          opacity: starOpacity,
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    );
                  },
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
                            style: GoogleFonts.getFont(
                              'Press Start 2P',
                              fontSize: 12,
                              color: const Color(0xFFE74B31),
                            ),
                          ),
                          content: Text(
                            'Вы уверены, что хотите начать заново? Текущий прогресс будет удален.',
                            style: GoogleFonts.getFont(
                              'Press Start 2P',
                              fontSize: 8,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'ОТМЕНА',
                                style: GoogleFonts.getFont(
                                  'Press Start 2P',
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                state.clearSaveAndReset();
                                Navigator.pushNamed(context, '/job_select');
                              },
                              child: Text(
                                'НАЧАТЬ',
                                style: GoogleFonts.getFont(
                                  'Press Start 2P',
                                  fontSize: 10,
                                  color: const Color(0xFFE74B31),
                                ),
                              ),
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
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFC0045C),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _SparklePainter extends CustomPainter {
  final double t;

  _SparklePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final centers = <Offset>[
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.75),
    ];

    for (var i = 0; i < centers.length; i++) {
      final phase = t + i * 0.25;
      final alpha = 0.3 + 0.5 * (0.5 + 0.5 * math.sin(2 * math.pi * phase));
      final radius = 2.0 + 3.0 * (0.5 + 0.5 * math.sin(2 * math.pi * phase));

      final paint = Paint()
        ..color = Colors.white.withOpacity(alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(centers[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
