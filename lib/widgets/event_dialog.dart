import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class EventDialog extends StatefulWidget {
  final GameEvent event;
  final Function(bool accepted, {int? quizAnswerIndex}) onResolve;

  const EventDialog({super.key, required this.event, required this.onResolve});

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  int? selectedOption;
  bool showTip = false;
  bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 4),
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        widget.event.title.toUpperCase(),
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: 16,
          color: Colors.cyanAccent,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.description,
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 10,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            if (widget.event.type == EventType.quiz && !showTip)
              ...List.generate(widget.event.options!.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == index
                            ? Colors.white
                            : Colors.grey[800],
                        foregroundColor: selectedOption == index
                            ? Colors.black
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedOption = index;
                          isCorrect = index == widget.event.correctAnswerIndex;
                          showTip = true;
                        });
                      },
                      child: Text(
                        widget.event.options![index],
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
                );
              }),
            if (showTip)
              Container(
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
                        color: isCorrect!
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.event.educationalTip ?? "",
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.event.type == EventType.voluntary && !showTip)
              Consumer<GameState>(
                builder: (context, state, child) {
                  bool needsEmergency =
                      state.walletBalance < widget.event.moneyImpact.abs();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _statChip(
                            '💰',
                            '${widget.event.moneyImpact} ₽',
                            Colors.yellowAccent,
                          ),
                          const SizedBox(width: 20),
                          _statChip(
                            '🎭',
                            '${widget.event.moodImpact > 0 ? "+" : ""}${widget.event.moodImpact}',
                            Colors.orangeAccent,
                          ),
                        ],
                      ),
                      if (needsEmergency)
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
              ),
          ],
        ),
      ),
      actions: [
        if (widget.event.type == EventType.random)
          _pixelButton("OK", () => widget.onResolve(true)),
        if (widget.event.type == EventType.voluntary) ...[
          _pixelButton("ОТКАЗАТЬСЯ", () => widget.onResolve(false)),
          _pixelButton(
            "СОГЛАСИТЬСЯ",
            () => widget.onResolve(true),
            isPrimary: true,
          ),
        ],
        if (widget.event.type == EventType.quiz && showTip)
          _pixelButton(
            "ПОНЯТНО",
            () => widget.onResolve(true, quizAnswerIndex: selectedOption),
          ),
      ],
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

  Widget _pixelButton(
    String label,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.cyanAccent : Colors.grey[800],
        foregroundColor: isPrimary ? Colors.black : Colors.white,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 8)),
    );
  }
}
