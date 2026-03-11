import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../app_state.dart';

class VoluntaryView extends StatelessWidget {
  final GameEvent event;

  const VoluntaryView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, state, child) {
        bool needsEmergency = state.walletBalance < event.moneyImpact.abs();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statChip('💰', '${event.moneyImpact} ₽', Colors.yellowAccent),
                const SizedBox(width: 20),
                _statChip(
                  '🎭',
                  '${event.moodImpact > 0 ? "+" : ""}${event.moodImpact}',
                  Colors.orangeAccent,
                ),
              ],
            ),
            if (needsEmergency && event.moneyImpact < 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '⚠️ Придется залезть в Подушку!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _statChip(String icon, String label, Color color) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
