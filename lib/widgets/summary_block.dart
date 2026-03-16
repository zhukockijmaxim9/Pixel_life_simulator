import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryBlock extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String sub;

  const SummaryBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.cyanAccent,
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
