import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/job.dart';
import '../models/goal.dart';
import '../data/game_data.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int _step = 0; // 0 = Goal, 1 = Budget, 2 = Confirmation
  Job? _tempJob;
  GameGoal? _tempGoal;
  double _walletPct = 40;
  double _emergencyPct = 30;
  double _mandatoryPct = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final job = ModalRoute.of(context)?.settings.arguments as Job?;
    if (job != null && _tempJob == null) {
      _tempJob = job;
    }
  }

  double get _jobSalary => _tempJob?.salary ?? 45000;
  double get _surplus => _jobSalary - (_tempGoal?.monthlyContribution ?? 0.0);

  void _goBack() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context); // Back to job selection
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['ВЫБЕРИ ЦЕЛЬ', 'НАСТРОЙ БЮДЖЕТ', 'ПОДТВЕРЖДЕНИЕ'];
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          titles[_step],
          style: GoogleFonts.getFont('Press Start 2P', fontSize: 12),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goBack,
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          switch (_step) {
            case 0:
              return _buildGoalStep();
            case 1:
              return _buildBudgetStep();
            case 2:
              return _buildConfirmStep(state);
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  // ===== STEP 0: Goal Selection =====
  Widget _buildGoalStep() {
    return Column(
      children: [
        // Job header
        if (_tempJob != null) _jobHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'НА ЧТО БУДЕШЬ КОПИТЬ?',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Достигни цели и получи бонусные баллы для покупки крутого мерча за достижение!',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.white38,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ...GameData.availableGoals.map((goal) => _goalCard(goal)),
              ],
            ),
          ),
        ),
        _navButton(
          label: 'ДАЛЕЕ',
          active: _tempGoal != null,
          onPressed: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  // ===== STEP 1: Budget Distribution =====
  Widget _buildBudgetStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'РАСПРЕДЕЛИ БЮДЖЕТ',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Зарплата: ${_jobSalary.toInt()} ₽  |  Аренда: ${GameData.RENT.toInt()} ₽',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'На цель (фикс): ${(_tempGoal?.monthlyContribution ?? 0).toInt()} ₽',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.yellowAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Остаток к распределению: ${_surplus.toInt()} ₽',
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
                _sliderDescription(
                  'Свободные деньги на развлечение, досуг и покупку еды, если обязательные траты кончились.',
                ),
                const SizedBox(height: 16),
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
                _sliderDescription(
                  'Запас на случай ЧП и непредвиденных штрафов или поломок.',
                ),
                const SizedBox(height: 16),
                _budgetSlider(
                  label: 'ОБЯЗАТЕЛЬНЫЕ ТРАТЫ',
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
                _sliderDescription(
                  'Деньги на еду и ежемесячную оплату аренды жилья.',
                ),
              ],
            ),
          ),
        ),
        _navButton(
          label: 'ДАЛЕЕ',
          active: true,
          onPressed: () => setState(() => _step = 2),
        ),
      ],
    );
  }

  // ===== STEP 2: Confirmation =====
  Widget _buildConfirmStep(GameState state) {
    double walletMoney = _surplus * (_walletPct / 100);
    double emergencyMoney = _surplus * (_emergencyPct / 100);
    double mandatoryMoney = _surplus * (_mandatoryPct / 100);
    double goalMoney = _tempGoal?.monthlyContribution ?? 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'СВОДКА',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 12,
                    color: Colors.yellowAccent,
                  ),
                ),
                const SizedBox(height: 24),

                // Job
                _summaryBlock(
                  icon: _tempJob!.icon,
                  title: 'ПРОФЕССИЯ',
                  value: _tempJob!.title,
                  sub: '${_jobSalary.toInt()} ₽/мес',
                ),
                const SizedBox(height: 16),

                // Goal
                _summaryBlock(
                  icon: '🎯',
                  title: 'ЦЕЛЬ',
                  value: _tempGoal!.title,
                  sub:
                      '${_tempGoal!.cost.toInt()} ₽  (${goalMoney.toInt()} ₽/мес)',
                ),
                const SizedBox(height: 16),

                // Budget breakdown
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'БЮДЖЕТ НА МЕСЯЦ',
                        style: GoogleFonts.getFont(
                          'Press Start 2P',
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _summaryRow(
                        'Зарплата',
                        '${_jobSalary.toInt()} ₽',
                        Colors.white,
                      ),
                      _summaryRow(
                        'На цель (${_tempGoal!.title})',
                        '-${goalMoney.toInt()} ₽',
                        Colors.yellowAccent,
                      ),
                      const Divider(color: Colors.white24),
                      _summaryRow(
                        'Остаток',
                        '${_surplus.toInt()} ₽',
                        Colors.cyanAccent,
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        '  👛 Кошелек (${_walletPct.toInt()}%)',
                        '${walletMoney.toInt()} ₽',
                        Colors.yellowAccent,
                      ),
                      _summaryRow(
                        '  🛡️ Подушка (${_emergencyPct.toInt()}%)',
                        '${emergencyMoney.toInt()} ₽',
                        Colors.orangeAccent,
                      ),
                      _summaryRow(
                        '  📜 Обязат. (${_mandatoryPct.toInt()}%)',
                        '${mandatoryMoney.toInt()} ₽',
                        Colors.lightBlueAccent,
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        '🏠 Аренда (списание 2-го числа)',
                        '-${GameData.RENT.toInt()} ₽',
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _navButton(
          label: 'НАЧАТЬ ЖИЗНЬ',
          active: true,
          onPressed: () {
            state.setupGame(
              _tempJob!,
              _tempGoal!,
              walletPct: _walletPct.toInt(),
              emergencyPct: _emergencyPct.toInt(),
              mandatoryPct: _mandatoryPct.toInt(),
              isNewGame: state.currentMonth <= 1,
            );
            Navigator.pushReplacementNamed(context, '/game');
          },
        ),
      ],
    );
  }

  // ===== Shared Widgets =====

  Widget _jobHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.cyanAccent.withValues(alpha: 0.06),
      child: Row(
        children: [
          Text(_tempJob!.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text(
            '${_tempJob!.title}  •  ${_jobSalary.toInt()} ₽/мес',
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 7,
              color: Colors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(GameGoal goal) {
    bool isSelected = _tempGoal == goal;
    return GestureDetector(
      onTap: () => setState(() => _tempGoal = goal),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Text('🎯', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
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
                        '${goal.cost.toInt()} ₽  (${goal.monthlyContribution.toInt()} ₽/мес)',
                        style: TextStyle(
                          fontSize: 7,
                          color: isSelected ? Colors.black54 : Colors.grey,
                        ),
                      ),
                      Text(
                        '+${goal.pointsReward} 🏆',
                        style: TextStyle(
                          fontSize: 7,
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

  Widget _navButton({
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

  Widget _sliderDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: 6,
          color: Colors.white24,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _summaryBlock({
    required String icon,
    required String title,
    required String value,
    required String sub,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 7,
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

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
            value,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 7,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
