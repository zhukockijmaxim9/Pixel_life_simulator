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
  // Initial Setup State (Job/Goal)
  Job? _tempJob;
  GameGoal? _tempGoal;

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
        automaticallyImplyLeading: false,
      ),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          return _buildSetupFlow(state, context);
        },
      ),
    );
  }

  // --- SETUP FLOW (Job/Goal) ---
  Widget _buildSetupFlow(GameState state, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('1. ВЫБЕРИТЕ РАБОТУ'),
                const SizedBox(height: 16),
                ...GameState.availableJobs.map(
                  (job) => _selectionCard(
                    title: job.title,
                    subtitle: '${job.salary.toStringAsFixed(0)} ₽/мес',
                    icon: job.icon,
                    isSelected: _tempJob == job,
                    onTap: () => setState(() => _tempJob = job),
                  ),
                ),
                const SizedBox(height: 32),
                _sectionTitle('2. ВЫБЕРИТЕ ЦЕЛЬ'),
                const SizedBox(height: 16),
                ...GameState.availableGoals.map(
                  (goal) => _selectionCard(
                    title: goal.title,
                    subtitle: '${goal.cost.toStringAsFixed(0)} ₽',
                    icon: '🎯',
                    isSelected: _tempGoal == goal,
                    onTap: () => setState(() => _tempGoal = goal),
                  ),
                ),
              ],
            ),
          ),
        ),
        _actionButton(
          label: 'НАЧАТЬ ЖИЗНЬ',
          active: _tempJob != null && _tempGoal != null,
          onPressed: () {
            state.setupGame(_tempJob!, _tempGoal!);
            Navigator.pushReplacementNamed(context, '/game');
          },
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        'Press Start 2P',
        fontSize: 10,
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

  Widget _actionButton({
    required String label,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: active ? Colors.cyanAccent : Colors.grey,
          ),
          onPressed: active ? onPressed : null,
          child: Text(label),
        ),
      ),
    );
  }
}
