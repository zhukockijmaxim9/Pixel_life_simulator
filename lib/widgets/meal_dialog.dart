import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_state.dart';

class MealDialog extends StatelessWidget {
  final Function(MealType) onChosen;

  const MealDialog({super.key, required this.onChosen});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 4),
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        'ПОРА ПОДКРЕПИТЬСЯ!',
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: 14,
          color: Colors.yellowAccent,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _mealOption(
            context,
            'ЭКОНОМ',
            '600 ₽',
            '-10 настроения',
            Colors.redAccent,
            () => onChosen(MealType.economy),
          ),
          _mealOption(
            context,
            'СТАНДАРТ',
            '1500 ₽',
            '+2 настроения',
            Colors.white,
            () => onChosen(MealType.standard),
          ),
          _mealOption(
            context,
            'ЛЮКС',
            '3500 ₽',
            '+15 настроения',
            Colors.cyanAccent,
            () => onChosen(MealType.luxury),
          ),
          _mealOption(
            context,
            'ПРОПУСТИТЬ',
            '0 ₽',
            '-25 настроения\n-2000 ₽ лечение',
            Colors.grey,
            () => onChosen(MealType.skip),
          ),
        ],
      ),
    );
  }

  Widget _mealOption(
    BuildContext context,
    String title,
    String cost,
    String effect,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            color: Colors.white.withValues(alpha: 0.05),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 10,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      effect,
                      style: const TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                cost,
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 8,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
