import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetSlider extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final String description;

  const BudgetSlider({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.white70,
              ),
            ),
            Text(
              '${value.toInt()} ₽',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: null,
          activeColor: Colors.cyanAccent,
          inactiveColor: Colors.white10,
          onChanged: (val) {
            double snapped = (val / 500).round() * 500.0;
            if ((max - val).abs() < 250) {
              snapped = max;
            } else {
              snapped = snapped.clamp(0.0, max);
            }
            onChanged(snapped);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            description,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 6,
              color: Colors.white24,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
