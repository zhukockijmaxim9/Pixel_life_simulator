import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/goal.dart';
import '../data/game_data.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  GameGoal? _selectedGoal;
  double _walletPct = 0;
  double _emergencyPct = 0;
  double _mandatoryPct = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = Provider.of<GameState>(context, listen: false);
      _selectedGoal = state.selectedGoal;
      _walletPct = state.walletPercentage.toDouble();
      _emergencyPct = state.emergencyPercentage.toDouble();
      _mandatoryPct = state.mandatoryPercentage.toDouble();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    // Calculate current month's distribution preview
    double currentMonthGoalContrib = _selectedGoal?.monthlyContribution ?? 0;
    double currentMonthSurplus =
        (state.selectedJob?.salary ?? 0) - currentMonthGoalContrib;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'ПЛАНИРОВАНИЕ',
          style: GoogleFonts.getFont('Press Start 2P', fontSize: 12),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('ВЫБОР ЦЕЛИ'),
                  const SizedBox(height: 12),
                  ...GameData.availableGoals.map((goal) => _goalCard(goal)),

                  const SizedBox(height: 32),
                  _sectionHeader('РАСПРЕДЕЛЕНИЕ ОСТАТКА'),
                  const SizedBox(height: 8),
                  Text(
                    'Остаток к распределению в этом месяце: ${currentMonthSurplus.toInt()} ₽',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 7,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _budgetSlider(
                    label: 'КОШЕЛЕК',
                    value: _walletPct,
                    surplus: currentMonthSurplus,
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
                    surplus: currentMonthSurplus,
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
                    surplus: currentMonthSurplus,
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
                ],
              ),
            ),
          ),
          _applyButton(state),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        'Press Start 2P',
        fontSize: 10,
        color: Colors.grey,
      ),
    );
  }

  Widget _goalCard(GameGoal goal) {
    bool isSelected = _selectedGoal?.title == goal.title;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = goal),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyanAccent.withValues(alpha: 0.1)
              : const Color(0xFF1E1E1E),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Text(
              isSelected ? '▶' : ' ',
              style: const TextStyle(color: Colors.cyanAccent),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                goal.title,
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 8,
                  color: isSelected ? Colors.cyanAccent : Colors.white,
                ),
              ),
            ),
            Text(
              '${goal.cost.toInt()}₽',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetSlider({
    required String label,
    required double value,
    required double surplus,
    required ValueChanged<double> onChanged,
  }) {
    double moneyAmount = surplus * (value / 100);
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
                fontSize: 7,
                color: Colors.white70,
              ),
            ),
            Text(
              '${value.toInt()}% (${moneyAmount.toInt()} ₽)',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 7,
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _applyButton(GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_selectedGoal != null) {
              state.setGoal(_selectedGoal!);
            }
            state.updateDistribution(
              _walletPct.toInt(),
              _emergencyPct.toInt(),
              _mandatoryPct.toInt(),
            );
            Navigator.pop(context);
          },
          child: Text(
            'ПРИМЕНИТЬ ИЗМЕНЕНИЯ',
            style: GoogleFonts.getFont('Press Start 2P', fontSize: 10),
          ),
        ),
      ),
    );
  }
}
