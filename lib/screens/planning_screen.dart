import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  Job? selectedJob;
  GameGoal? selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'ПЛАНИРОВАНИЕ',
          style: GoogleFonts.getFont('Press Start 2P', fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('ВЫБЕРИ РАБОТУ'),
                  const SizedBox(height: 16),
                  ...GameState.availableJobs.map(
                    (job) => _selectionCard(
                      title: job.title,
                      subtitle: '${job.salary.toStringAsFixed(0)} ₽/мес',
                      icon: job.icon,
                      isSelected: selectedJob == job,
                      onTap: () => setState(() => selectedJob = job),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _sectionTitle('ВЫБЕРИ МЕЧТУ'),
                  const SizedBox(height: 16),
                  ...GameState.availableGoals.map(
                    (goal) => _selectionCard(
                      title: goal.title,
                      subtitle: '${goal.cost.toStringAsFixed(0)} ₽',
                      icon: '🎯',
                      isSelected: selectedGoal == goal,
                      onTap: () => setState(() => selectedGoal = goal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selectedJob != null && selectedGoal != null)
                      ? Colors.cyanAccent
                      : Colors.grey,
                ),
                onPressed: (selectedJob != null && selectedGoal != null)
                    ? () {
                        context.read<GameState>().setupGame(
                          selectedJob!,
                          selectedGoal!,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/game',
                          (route) => false,
                        );
                      }
                    : null,
                child: const Text('В ПУТЬ!'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        'Press Start 2P',
        fontSize: 12,
        color: Colors.yellowAccent,
      ),
    );
  }

  Widget _selectionCard({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.white,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 8,
                      color: isSelected ? Colors.black54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
