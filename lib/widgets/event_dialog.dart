import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../models/enums.dart';
import 'event_views/quiz_view.dart';
import 'event_views/payment_view.dart';
import 'event_views/voluntary_view.dart';

class EventDialog extends StatefulWidget {
  final GameEvent event;
  final Function(bool accepted, {int? quizAnswerIndex, int? courseChoice}) onResolve;

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
        style: GoogleFonts.getFont('Press Start 2P', fontSize: 14, color: _titleColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event.description, style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, height: 1.5)),
            const SizedBox(height: 20),
            _buildEventSpecificContent(),
          ],
        ),
      ),
      actions: _buildActions(),
    );
  }

  Widget _buildEventSpecificContent() {
    switch (widget.event.type) {
      case EventType.quiz:
        return QuizView(
          event: widget.event,
          selectedOption: selectedOption,
          showTip: showTip,
          isCorrect: isCorrect,
          onOptionSelected: (index) => setState(() {
            selectedOption = index;
            isCorrect = index == widget.event.correctAnswerIndex;
            showTip = true;
          }),
        );
      case EventType.rent:
      case EventType.payment:
        return PaymentView(event: widget.event);
      case EventType.voluntary:
        return VoluntaryView(event: widget.event);
      case EventType.course:
        return _buildCourseOptions();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCourseOptions() {
    return Column(
      children: List.generate(widget.event.options!.length, (index) {
        bool isRefuse = index == widget.event.options!.length - 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isRefuse ? Colors.grey[800] : Colors.cyanAccent.withValues(alpha: 0.2),
                foregroundColor: isRefuse ? Colors.grey : Colors.cyanAccent,
                side: BorderSide(color: isRefuse ? Colors.grey : Colors.cyanAccent),
              ),
              onPressed: () => widget.onResolve(true, courseChoice: index),
              child: Text(
                index < 2 ? '${widget.event.options![index]} — 5000₽' : widget.event.options![index],
                style: GoogleFonts.getFont('Press Start 2P', fontSize: 8),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color get _titleColor {
    switch (widget.event.type) {
      case EventType.rent:
      case EventType.payment: return Colors.redAccent;
      case EventType.course: return Colors.purpleAccent;
      case EventType.quiz: return Colors.yellowAccent;
      default: return Colors.cyanAccent;
    }
  }

  List<Widget> _buildActions() {
    switch (widget.event.type) {
      case EventType.random:
        return [_pixelButton("OK", () => widget.onResolve(true))];
      case EventType.voluntary:
        return [
          _pixelButton("ОТКАЗАТЬСЯ", () => widget.onResolve(false)),
          _pixelButton("СОГЛАСИТЬСЯ", () => widget.onResolve(true), isPrimary: true),
        ];
      case EventType.quiz:
        if (showTip) return [_pixelButton("ПОНЯТНО", () => widget.onResolve(true, quizAnswerIndex: selectedOption))];
        return [];
      case EventType.rent:
        return [_pixelButton("ОПЛАТИТЬ", () => widget.onResolve(true), isPrimary: true)];
      case EventType.payment:
        return [
          _pixelButton("ОТЛОЖИТЬ", () => widget.onResolve(false)),
          _pixelButton("ОПЛАТИТЬ", () => widget.onResolve(true), isPrimary: true),
        ];
      case EventType.course:
        return [];
    }
  }

  Widget _pixelButton(String label, VoidCallback onPressed, {bool isPrimary = false}) {
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
