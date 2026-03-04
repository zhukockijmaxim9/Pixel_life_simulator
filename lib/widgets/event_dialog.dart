import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class EventDialog extends StatefulWidget {
  final GameEvent event;
  final Function(bool accepted, {int? quizAnswerIndex, int? courseChoice})
  onResolve;

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
          fontSize: 14,
          color: _titleColor,
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

            // QUIZ options
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

            // Quiz tip
            if (showTip && widget.event.type == EventType.quiz)
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

            // RENT info
            if (widget.event.type == EventType.rent)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.redAccent.withValues(alpha: 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏠', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(
                      '${widget.event.moneyImpact.toInt()} ₽',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),

            // COURSE options
            if (widget.event.type == EventType.course)
              ...List.generate(widget.event.options!.length, (index) {
                bool isRefuse = index == widget.event.options!.length - 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRefuse
                            ? Colors.grey[800]
                            : Colors.cyanAccent.withValues(alpha: 0.2),
                        foregroundColor: isRefuse
                            ? Colors.grey
                            : Colors.cyanAccent,
                        side: BorderSide(
                          color: isRefuse ? Colors.grey : Colors.cyanAccent,
                        ),
                      ),
                      onPressed: () {
                        widget.onResolve(true, courseChoice: index);
                      },
                      child: Text(
                        index < 2
                            ? '${widget.event.options![index]} — 5000₽'
                            : widget.event.options![index],
                        style: GoogleFonts.getFont(
                          'Press Start 2P',
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                );
              }),

            // VOLUNTARY stat chips
            if (widget.event.type == EventType.voluntary)
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
                      if (needsEmergency && widget.event.moneyImpact < 0)
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
      actions: _buildActions(),
    );
  }

  Color get _titleColor {
    switch (widget.event.type) {
      case EventType.rent:
        return Colors.redAccent;
      case EventType.course:
        return Colors.purpleAccent;
      case EventType.quiz:
        return Colors.yellowAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  List<Widget> _buildActions() {
    switch (widget.event.type) {
      case EventType.random:
        return [_pixelButton("OK", () => widget.onResolve(true))];
      case EventType.voluntary:
        return [
          _pixelButton("ОТКАЗАТЬСЯ", () => widget.onResolve(false)),
          _pixelButton(
            "СОГЛАСИТЬСЯ",
            () => widget.onResolve(true),
            isPrimary: true,
          ),
        ];
      case EventType.quiz:
        if (showTip) {
          return [
            _pixelButton(
              "ПОНЯТНО",
              () => widget.onResolve(true, quizAnswerIndex: selectedOption),
            ),
          ];
        }
        return [];
      case EventType.rent:
        return [
          _pixelButton(
            "ОПЛАТИТЬ",
            () => widget.onResolve(true),
            isPrimary: true,
          ),
        ];
      case EventType.course:
        return []; // Buttons are inline (in content)
    }
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
