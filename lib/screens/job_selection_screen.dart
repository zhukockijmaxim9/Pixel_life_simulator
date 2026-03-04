import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_state.dart';

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
    final jobs = GameState.availableJobs;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Title
            Text(
              'ВЫБЕРИ СВОЮ',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ПЕРВУЮ ПРОФЕССИЮ',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 14,
                color: Colors.cyanAccent,
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
                    color: index == _currentPage
                        ? Colors.cyanAccent
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/planning',
                      arguments: jobs[_currentPage],
                    );
                  },
                  child: Text(
                    'ВЫБРАТЬ',
                    style: GoogleFonts.getFont('Press Start 2P', fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Job job, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(
          color: isActive ? Colors.cyanAccent : Colors.white24,
          width: isActive ? 3 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Job Icon
          Text(job.icon, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 24),

          // Job Title
          Text(
            job.title,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 14,
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
                fontSize: 12,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Net income hint
          Text(
            'После аренды: ${(job.salary - GameState.RENT).toStringAsFixed(0)} ₽',
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 7,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
