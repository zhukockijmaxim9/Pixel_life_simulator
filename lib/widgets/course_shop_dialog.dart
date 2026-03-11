import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/course.dart';
import '../data/game_data.dart';

class CourseShopDialog extends StatelessWidget {
  final double walletBalance;
  final List<String> completedCourses;
  final Function(Course) onBuy;

  const CourseShopDialog({
    super.key,
    required this.walletBalance,
    required this.completedCourses,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'МАГАЗИН КУРСОВ',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 12,
                    color: Colors.cyanAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Баланс: ${walletBalance.toInt()} ₽',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.yellowAccent,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: GameData.availableCourses.map((course) {
                    bool isBought = completedCourses.contains(course.title);
                    bool canAfford = walletBalance >= course.cost;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(course.icon, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: GoogleFonts.getFont(
                                        'Press Start 2P',
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${course.cost.toInt()} ₽',
                                      style: GoogleFonts.getFont(
                                        'Press Start 2P',
                                        fontSize: 8,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.description,
                            style: GoogleFonts.getFont(
                              'Press Start 2P',
                              fontSize: 6,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isBought
                                    ? Colors.grey
                                    : (canAfford ? Colors.greenAccent : Colors.redAccent.withValues(alpha: 0.5)),
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: (isBought || !canAfford)
                                  ? null
                                  : () => onBuy(course),
                              child: Text(
                                isBought
                                    ? 'ИЗУЧЕНО'
                                    : (canAfford ? 'КУПИТЬ' : 'НЕДОСТАТОЧНО СРЕДСТВ'),
                                style: GoogleFonts.getFont(
                                  'Press Start 2P',
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
