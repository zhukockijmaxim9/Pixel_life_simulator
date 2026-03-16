import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/job.dart';
import '../models/goal.dart';
import '../data/game_data.dart';
import '../widgets/goal_card.dart';
import '../widgets/budget_slider.dart';
import '../widgets/summary_block.dart';
import '../ui_theme.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int _step = 0; // 0 = Goal, 1 = Budget, 2 = Confirmation
  Job? _tempJob;
  GameGoal? _tempGoal;
  double _walletAlloc = 10000;
  double _deferredAlloc = 5000;
  double _mandatoryAlloc = 15000;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final job = ModalRoute.of(context)?.settings.arguments as Job?;
    if (job != null && _tempJob == null) {
      _tempJob = job;
    }
  }

  double get _jobSalary => _tempJob?.salary ?? 45000;
  double get _currentRent => GameData.getRent(_tempJob?.tier ?? 1);
  
  // Get carry-over from state
  double get _carryOver {
    final state = Provider.of<GameState>(context, listen: false);
    return state.carryOver;
  }
  
  double get _totalBudget => _jobSalary + _carryOver;
  double get _surplus => _totalBudget - (_tempGoal?.monthlyContribution ?? 0.0);

  void _goBack() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
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
            case 0: return _buildGoalStep(state);
            case 1: return _buildBudgetStep();
            case 2: return _buildConfirmStep(state);
            default: return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildGoalStep(GameState state) {
    return Column(
      children: [
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
                    fontSize: 10,
                    color: const Color(0xFFFAC541),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Месяц ${state.currentMonth}. Достигни цель и получи бонусные баллы для мерча!',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 8,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ...GameState.getGoalsForMonth(state.currentMonth).map((goal) => GoalCard(
                  goal: goal,
                  isSelected: _tempGoal == goal,
                  onTap: () => setState(() => _tempGoal = goal),
                )),
              ],
            ),
          ),
        ),
        _navButton(label: 'ДАЛЕЕ', active: _tempGoal != null, onPressed: () => setState(() => _step = 1)),
      ],
    );
  }

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
                    fontSize: 10,
                    color: const Color(0xFFFAC541),
                  ),
                ),
                const SizedBox(height: 8),
                if (_carryOver > 0) ...[
                  Text(
                    'Зарплата: ${_jobSalary.toInt()} ₽ + остаток: ${_carryOver.toInt()} ₽',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 9,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Всего: ${_totalBudget.toInt()} ₽  |  Аренда: ${_currentRent.toInt()} ₽',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 9,
                      color: const Color(0xFFFAC541),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Зарплата: ${_jobSalary.toInt()} ₽  |  Аренда: ${_currentRent.toInt()} ₽',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 9,
                      color: Colors.white70,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text('На цель (фикс): ${(_tempGoal?.monthlyContribution ?? 0).toInt()} ₽', style: GoogleFonts.getFont('Press Start 2P', fontSize: 9, color: Colors.yellowAccent)),
                const SizedBox(height: 4),
                Text(
                  'Остаток к распределению: ${_surplus.toInt()} ₽',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 9,
                    color: AppColors.accent3,
                  ),
                ),
                const SizedBox(height: 24),
                BudgetSlider(
                  label: 'КОШЕЛЕК',
                  value: _walletAlloc,
                  max: _surplus,
                  onChanged: (val) {
                    double remaining = _surplus - _deferredAlloc - _mandatoryAlloc;
                    setState(() => _walletAlloc = val.clamp(0, remaining));
                  },
                  description: 'Свободные деньги на развлечение, досуг и покупку еды, если обязательные траты кончились.',
                ),
                const SizedBox(height: 16),
                BudgetSlider(
                  label: 'ОТЛОЖЕННЫЕ',
                  value: _deferredAlloc,
                  max: _surplus,
                  onChanged: (val) {
                    double remaining = _surplus - _walletAlloc - _mandatoryAlloc;
                    setState(() => _deferredAlloc = val.clamp(0, remaining));
                  },
                  description: 'Деньги на курсы и непредвиденные расходы.',
                ),
                const SizedBox(height: 16),
                BudgetSlider(
                  label: 'ОБЯЗАТЕЛЬНЫЕ ТРАТЫ',
                  value: _mandatoryAlloc,
                  max: _surplus,
                  onChanged: (val) {
                    double remaining = _surplus - _walletAlloc - _deferredAlloc;
                    setState(() => _mandatoryAlloc = val.clamp(0, remaining));
                  },
                  description: 'Деньги на еду и ежемесячную оплату аренды жилья.',
                ),
              ],
            ),
          ),
        ),
        _navButton(label: 'ДАЛЕЕ', active: (_walletAlloc + _deferredAlloc + _mandatoryAlloc - _surplus).abs() < 0.1, onPressed: () => setState(() => _step = 2)),
      ],
    );
  }

  Widget _buildConfirmStep(GameState state) {
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
                    fontSize: 14,
                    color: const Color(0xFFFAC541),
                  ),
                ),
                const SizedBox(height: 24),
                SummaryBlock(
                  icon: _tempJob?.icon ?? '💼',
                  title: 'ПРОФЕССИЯ',
                  value: _tempJob?.title ?? 'Не выбрана',
                  sub: '${_jobSalary.toInt()} ₽/мес',
                ),
                const SizedBox(height: 16),
                SummaryBlock(
                  icon: '🎯',
                  title: 'ЦЕЛЬ',
                  value: _tempGoal?.title ?? 'Не выбрана',
                  sub: '${(_tempGoal?.cost ?? 0).toInt()} ₽  (${goalMoney.toInt()} ₽/мес)',
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border.all(color: Colors.white24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('БЮДЖЕТ НА МЕСЯЦ', style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 16),
                      _summaryRow('Зарплата', '${_jobSalary.toInt()} ₽', Colors.white),
                      if (_carryOver > 0) ...[
                        _summaryRow('Остаток с прошлого месяца', '+${_carryOver.toInt()} ₽', Colors.greenAccent),
                        _summaryRow('Всего доступно', '${_totalBudget.toInt()} ₽', Colors.white),
                      ],
                      _summaryRow('На цель (${_tempGoal?.title ?? ''})', '-${goalMoney.toInt()} ₽', Colors.yellowAccent),
                      const Divider(color: Colors.white24),
                      _summaryRow('Остаток', '${_surplus.toInt()} ₽', Colors.cyanAccent),
                      const SizedBox(height: 12),
                      _summaryRow('  👛 Кошелек', '${_walletAlloc.toInt()} ₽', const Color(0xFFFAC541)),
                      _summaryRow('  📦 Отложенные', '${_deferredAlloc.toInt()} ₽', Colors.orangeAccent),
                      _summaryRow('  📜 Обязат.', '${_mandatoryAlloc.toInt()} ₽', Colors.lightBlueAccent),
                      const SizedBox(height: 12),
                      _summaryRow('🏠 Аренда (списание 2-го числа)', '-${_currentRent.toInt()} ₽', Colors.redAccent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _navButton(
          label: 'НАЧАТЬ ЖИЗНЬ',
          active: (_walletAlloc + _deferredAlloc + _mandatoryAlloc - _surplus).abs() < 0.1,
          onPressed: () {
            if (_tempJob != null && _tempGoal != null) {
              state.setupGame(_tempJob!, _tempGoal!, walletAlloc: _walletAlloc, deferredAlloc: _deferredAlloc, mandatoryAlloc: _mandatoryAlloc, isNewGame: state.currentMonth <= 1);
              Navigator.pushReplacementNamed(context, '/game');
            }
          },
        ),
      ],
    );
  }

  Widget _jobHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        gradient: AppColors.gradient,
      ),
      child: Row(
        children: [
          Text(_tempJob!.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Text(
            '${_tempJob!.title}  •  ${_jobSalary.toInt()} ₽/мес',
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 9,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({required String label, required bool active, required VoidCallback onPressed}) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: active ? AppColors.gradient : null,
              color: active ? null : Colors.grey,
            ),
            child: TextButton(
              onPressed: active ? onPressed : null,
              child: Text(
                label,
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: GoogleFonts.getFont('Press Start 2P', fontSize: 9, color: Colors.white70))),
          Text(value, style: GoogleFonts.getFont('Press Start 2P', fontSize: 9, color: color)),
        ],
      ),
    );
  }
}
