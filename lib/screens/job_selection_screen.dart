import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/job.dart';
import '../ui_theme.dart';

class JobSelectionScreen extends StatefulWidget {
  const JobSelectionScreen({super.key});

  @override
  State<JobSelectionScreen> createState() => _JobSelectionScreenState();
}

class _JobSelectionScreenState extends State<JobSelectionScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, state, child) {
        final jobs = state.getAvailableJobsForMonth();
        final isFirstMonth = state.currentMonth <= 1;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Title
                Text(
                  isFirstMonth ? 'ВЫБЕРИ СВОЮ' : 'ВЫБЕРИ',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return AppColors.gradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    );
                  },
                  child: Text(
                    isFirstMonth ? 'ПЕРВУЮ ПРОФЕССИЮ' : 'ПРОФЕССИЮ',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!isFirstMonth)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Месяц ${state.currentMonth}',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  '← ЛИСТАЙ →',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Swipeable Job Cards
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: jobs.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final isActive = index == _currentPage;
                      return AnimatedScale(
                        scale: isActive ? 1.0 : 0.9,
                        duration: const Duration(milliseconds: 250),
                        child: _buildJobCard(job, isActive),
                      );
                    },
                  ),
                ),

                // Dot Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    jobs.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: index == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: index == _currentPage
                            ? AppColors.gradient
                            : null,
                        color: index == _currentPage
                            ? null
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Select Button
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: AppColors.gradient,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/planning',
                              arguments: jobs[_currentPage],
                            );
                          },
                          child: Text(
                            'ВЫБРАТЬ',
                            style: GoogleFonts.getFont(
                              'Press Start 2P',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobCard(Job job, bool isActive) {
    bool isTier2 = job.tier == 2;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: isActive ? AppColors.accent2 : Colors.white24,
          width: isActive ? 3 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accent2.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tier badge
          if (isTier2)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
              ),
              child: Text(
                '⭐ УРОВЕНЬ 2',
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 7,
                  color: Colors.white,
                ),
              ),
            ),
          if (isTier2) const SizedBox(height: 12),

          // Emoji иконка профессии
          SizedBox(
            width: 180,
            height: 180,
            child: Center(
              child: Text(
                job.icon,
                style: const TextStyle(fontSize: 100),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Job Title
          Text(
            job.title,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Salary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.cyanAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${job.salary.toStringAsFixed(0)} ₽/мес',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 14,
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
