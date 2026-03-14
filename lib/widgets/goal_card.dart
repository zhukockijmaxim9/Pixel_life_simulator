import 'package:flutter/material.dart';

import '../models/goal.dart';


class GoalCard extends StatelessWidget {
  final GameGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          border: Border.all(
            color: isSelected ? const Color(0xFFEB9B2A) : const Color(0xFF444444),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEB9B2A).withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF241424),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF8F1162),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontFamily: 'Hometown',
                      fontSize: 20,
                      color: Color(0xFFC0045C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${goal.cost.toInt()} ₽',
                    style: const TextStyle(
                      fontFamily: 'Hometown',
                      fontSize: 18,
                      color: Color(0xFFEB9B2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${goal.monthlyContribution.toInt()} ₽/мес',
                    style: TextStyle(
                      fontFamily: 'Hometown',
                      fontSize: 14,
                      color: const Color(0xFFC5035C).withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${goal.pointsReward}',
                  style: const TextStyle(
                    fontFamily: 'Hometown',
                    fontSize: 14,
                    color: Color(0xFFC5035C),
                  ),
                ),
                const Text(
                  'баллов',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFC5035C),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF66BB6A),
                    size: 20,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
