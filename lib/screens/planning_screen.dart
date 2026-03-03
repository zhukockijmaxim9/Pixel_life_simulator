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

  // Budgeting State
  Lifestyle _selectedLifestyle = GameState.lifestyles[1]; // Standard
  double _wallet = 0;
  double _emergency = 0;
  double _savings = 0;

  bool _initialized = false;

  void _initBudget(GameState state) {
    if (_initialized) return;

    double salary = state.selectedJob?.salary ?? 35000;
    double available = salary - _selectedLifestyle.cost;

    // Default distribution: 50/30/20
    _wallet = (available * 0.5).floorToDouble();
    _emergency = (available * 0.3).floorToDouble();
    _savings = (available * 0.2).floorToDouble();

    _initialized = true;
  }

  double get _totalAllocated => _wallet + _emergency + _savings;
  double _getAvailableBudget(GameState state) {
    double salary = state.selectedJob?.salary ?? 35000;
    return salary - _selectedLifestyle.cost;
  }

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
          // If no job selected yet, show setup flow
          if (state.selectedJob == null) {
            return _buildSetupFlow(state);
          }

          _initBudget(state);
          return _buildBudgetFlow(state);
        },
      ),
    );
  }

  // --- SETUP FLOW (Job/Goal) ---
  Widget _buildSetupFlow(GameState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('1. КЕМ БУДЕШЬ?'),
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
                _sectionTitle('2. О ЧЕМ МЕЧТАЕШЬ?'),
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
          label: 'УТВЕРДИТЬ ЦЕЛИ',
          active: _tempJob != null && _tempGoal != null,
          onPressed: () {
            state.setupGame(_tempJob!, _tempGoal!);
            // setupGame sets isPlanningPhase = true, so Consumer will rebuild and show BudgetFlow
          },
        ),
      ],
    );
  }

  // --- BUDGET FLOW (Accounts/Lifestyle) ---
  Widget _buildBudgetFlow(GameState state) {
    double available = _getAvailableBudget(state);
    double remaining = available - _totalAllocated;
    bool isValid = remaining.abs() < 1.0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(available, remaining),
                const SizedBox(height: 24),

                _sectionTitle('УРОВЕНЬ ЖИЗНИ (ЕДА)'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: GameState.lifestyles
                      .map((l) => _lifestyleButton(l))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedLifestyle.description,
                  style: const TextStyle(fontSize: 8, color: Colors.grey),
                ),
                Text(
                  'Эффект: ${_selectedLifestyle.moodImpact > 0 ? "+" : ""}${_selectedLifestyle.moodImpact.toInt()} настроения',
                  style: TextStyle(
                    fontSize: 8,
                    color: _selectedLifestyle.moodImpact >= 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                ),

                const SizedBox(height: 32),
                _sectionTitle('РАСПРЕДЕЛЕНИЕ СРЕДСТВ'),
                const SizedBox(height: 20),

                _budgetSlider(
                  label: 'КОШЕЛЕК 👜',
                  value: _wallet,
                  color: Colors.yellowAccent,
                  max: available,
                  description: 'На отдых и случайности',
                  onChanged: (v) => setState(() => _wallet = v),
                ),
                _budgetSlider(
                  label: 'ПОДУШКА 🏥',
                  value: _emergency,
                  color: Colors.orangeAccent,
                  max: available,
                  description: 'Спасет от долгов при поломке!',
                  onChanged: (v) => setState(() => _emergency = v),
                ),
                _budgetSlider(
                  label: 'КОПИЛКА 🎯',
                  value: _savings,
                  color: Colors.cyanAccent,
                  max: available,
                  description: 'Деньги на твою мечту',
                  onChanged: (v) => setState(() => _savings = v),
                ),
              ],
            ),
          ),
        ),
        _actionButton(
          label: 'НАЧАТЬ МЕСЯЦ',
          active: isValid,
          onPressed: () {
            state.distributeBudget(
              toWallet: _wallet,
              toEmergency: _emergency,
              toSavings: _savings,
              lifestyleCost: _selectedLifestyle.cost,
              moodImpact: _selectedLifestyle.moodImpact,
            );
            Navigator.pushReplacementNamed(context, '/game');
          },
        ),
      ],
    );
  }

  Widget _buildHeader(double total, double remaining) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ДОСТУПНО',
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
              Text(
                '${total.toStringAsFixed(0)} ₽',
                style: const TextStyle(fontSize: 14, color: Colors.cyanAccent),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ОСТАТОК',
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
              Text(
                '${remaining.toStringAsFixed(0)} ₽',
                style: TextStyle(
                  fontSize: 14,
                  color: remaining < 0 ? Colors.redAccent : Colors.yellowAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lifestyleButton(Lifestyle l) {
    bool isSelected = _selectedLifestyle == l;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedLifestyle = l;
        // Reset sliders as max changed
        _initialized = false;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          l.name.toUpperCase(),
          style: TextStyle(
            fontSize: 8,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _budgetSlider({
    required String label,
    required double value,
    required Color color,
    required double max,
    required String description,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 10)),
              Text(
                '${value.toStringAsFixed(0)} ₽',
                style: TextStyle(fontSize: 10, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value.clamp(0, max),
              min: 0,
              max: max,
              activeColor: color,
              inactiveColor: Colors.white24,
              onChanged: onChanged,
            ),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 7, color: Colors.grey),
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
