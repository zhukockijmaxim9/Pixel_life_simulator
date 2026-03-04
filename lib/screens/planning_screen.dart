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
  Job? _tempJob;
  GameGoal? _tempGoal;
  double _walletPct = 40;
  double _emergencyPct = 30;
  double _mandatoryPct = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive job from route arguments
    final job = ModalRoute.of(context)?.settings.arguments as Job?;
    if (job != null && _tempJob == null) {
      _tempJob = job;
    }
  }

  double get _jobSalary => _tempJob?.salary ?? 45000;
  double get _surplus =>
      _jobSalary - GameState.RENT - (_tempGoal?.monthlyContribution ?? 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'ПЛАНИРОВАНИЕ',
          style: GoogleFonts.getFont('Press Start 2P', fontSize: 14),
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

  Widget _buildSetupFlow(GameState state, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job header
                if (_tempJob != null) _jobHeader(),
                const SizedBox(height: 24),

                _sectionTitle('1. ВЫБЕРИТЕ ЦЕЛЬ'),
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
                const SizedBox(height: 32),

                _sectionTitle('2. РАСПРЕДЕЛЕНИЕ БЮДЖЕТА'),
                const SizedBox(height: 8),
                Text(
                  'Остаток после аренды и цели: ${_surplus.toInt()} ₽',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                _budgetSlider(
                  label: 'КОШЕЛЕК',
                  value: _walletPct,
                  onChanged: (val) {
                    setState(() {
                      double rem = 100 - val;
                      double oldSum = _emergencyPct + _mandatoryPct;
                      if (oldSum > 0) {
                        _emergencyPct = rem * (_emergencyPct / oldSum);
                        _mandatoryPct = rem * (_mandatoryPct / oldSum);
                      } else {
                        _emergencyPct = rem / 2;
                        _mandatoryPct = rem / 2;
                      }
                      _walletPct = val;
                    });
                  },
                ),
                _budgetSlider(
                  label: 'ПОДУШКА',
                  value: _emergencyPct,
                  onChanged: (val) {
                    setState(() {
                      double rem = 100 - val;
                      double oldSum = _walletPct + _mandatoryPct;
                      if (oldSum > 0) {
                        _walletPct = rem * (_walletPct / oldSum);
                        _mandatoryPct = rem * (_mandatoryPct / oldSum);
                      } else {
                        _walletPct = rem / 2;
                        _mandatoryPct = rem / 2;
                      }
                      _emergencyPct = val;
                    });
                  },
                ),
                _budgetSlider(
                  label: 'ОБЯЗАТЕЛЬНЫЕ',
                  value: _mandatoryPct,
                  onChanged: (val) {
                    setState(() {
                      double rem = 100 - val;
                      double oldSum = _walletPct + _emergencyPct;
                      if (oldSum > 0) {
                        _walletPct = rem * (_walletPct / oldSum);
                        _emergencyPct = rem * (_emergencyPct / oldSum);
                      } else {
                        _walletPct = rem / 2;
                        _emergencyPct = rem / 2;
                      }
                      _mandatoryPct = val;
                    });
                  },
                ),
                _distributionSummary(),
              ],
            ),
          ),
        ),
        _actionButton(
          label: 'НАЧАТЬ ЖИЗНЬ',
          active: _tempJob != null && _tempGoal != null,
          onPressed: () {
            state.setupGame(
              _tempJob!,
              _tempGoal!,
              walletPct: _walletPct.toInt(),
              emergencyPct: _emergencyPct.toInt(),
              mandatoryPct: _mandatoryPct.toInt(),
            );
            Navigator.pushReplacementNamed(context, '/game');
          },
        ),
      ],
    );
  }

  Widget _jobHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withValues(alpha: 0.08),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(_tempJob!.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tempJob!.title,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_tempJob!.salary.toInt()} ₽/мес',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 8,
                          color: isSelected ? Colors.black54 : Colors.grey,
                        ),
                      ),
                      Text(
                        '+${(GameState.availableGoals.firstWhere((g) => g.title == title)).pointsReward} баллов',
                        style: TextStyle(
                          fontSize: 8,
                          color: isSelected
                              ? Colors.black87
                              : Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: active ? onPressed : null,
          child: Text(
            label,
            style: GoogleFonts.getFont('Press Start 2P', fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _budgetSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    double moneyAmount = _surplus * (value / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.white70,
              ),
            ),
            Text(
              '${value.toInt()}% (${moneyAmount.toInt()} ₽)',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 8,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 20,
          activeColor: Colors.cyanAccent,
          inactiveColor: Colors.white10,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _distributionSummary() {
    double goalContrib = _tempGoal?.monthlyContribution ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'НА ЦЕЛЬ (ФИКС):',
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 8,
              color: Colors.grey,
            ),
          ),
          Text(
            '${goalContrib.toInt()} ₽',
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 8,
              color: Colors.yellowAccent,
            ),
          ),
        ],
      ),
    );
  }
}
