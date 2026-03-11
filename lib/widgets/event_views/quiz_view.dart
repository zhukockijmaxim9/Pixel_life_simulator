import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/event.dart';

class QuizView extends StatelessWidget {
  final GameEvent event;
  final int? selectedOption;
  final bool showTip;
  final bool? isCorrect;
  final Function(int) onOptionSelected;

  const QuizView({
    super.key,
    required this.event,
    required this.selectedOption,
    required this.showTip,
    required this.isCorrect,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (showTip) {
      return Container(
        padding: const EdgeInsets.all(10),
        color: isCorrect!
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCorrect! ? "ПРАВИЛЬНО!" : "НЕВЕРНО!",
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 10,
                color: isCorrect! ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.educationalTip ?? "",
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(event.options!.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption == index ? Colors.white : Colors.grey[800],
                foregroundColor: selectedOption == index ? Colors.black : Colors.white,
              ),
              onPressed: () => onOptionSelected(index),
              child: Text(
                event.options![index],
                style: const TextStyle(fontSize: 8),
              ),
            ),
          ),
        );
      }),
    );
  }
}
