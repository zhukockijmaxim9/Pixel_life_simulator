import 'package:flutter/material.dart';

class PixelProgressBar extends StatelessWidget {
  final double value; // 0 to 100
  final String label;

  const PixelProgressBar({super.key, required this.value, required this.label});

  Color _getColor() {
    if (value > 70) return Colors.greenAccent;
    if (value > 30) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          height: 24,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: value / 100,
                  child: Container(color: _getColor()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
