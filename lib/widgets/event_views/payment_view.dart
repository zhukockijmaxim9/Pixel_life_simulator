import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/event.dart';
import '../../models/enums.dart';

class PaymentView extends StatelessWidget {
  final GameEvent event;

  const PaymentView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.redAccent.withValues(alpha: 0.15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💰', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Text(
                '${event.moneyImpact.abs().toInt()} ₽',
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 14,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          if (event.type == EventType.payment)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Можно оплатить сейчас (+5🎭) или отложить на неделю (-15🎭)',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 6,
                  color: Colors.white70,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
