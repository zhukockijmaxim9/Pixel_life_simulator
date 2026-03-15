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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(
          color: const Color(0xFF362B1E),
          width: 1.5,
        ),
      ),
      child: Column(
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF362B1E),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${value.toInt()} ₽',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 8,
                    color: const Color(0xFFFAC541),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: max,
            divisions: null,
            activeColor: const Color(0xFFC5035C),
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
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              description,
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 6,
                color: Colors.white38,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
