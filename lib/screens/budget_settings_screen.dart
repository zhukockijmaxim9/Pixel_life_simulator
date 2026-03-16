import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  double _walletAlloc = 0;
  double _deferredAlloc = 0;
  double _mandatoryAlloc = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = Provider.of<GameState>(context, listen: false);
      // Use current actual balances if we are mid-game
      bool midGame = state.currentDay > 1 || state.currentMonth > 1;
      if (midGame) {
        _walletAlloc = state.walletBalance;
        _deferredAlloc = state.deferredFund;
        _mandatoryAlloc = state.mandatoryBalance;
      } else {
        _walletAlloc = state.walletAlloc;
        _deferredAlloc = state.deferredAlloc;
        _mandatoryAlloc = state.mandatoryAlloc;
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    // Calculate available money for redistribution
    double currentMonthSurplus =
        state.walletBalance + state.deferredFund + state.mandatoryBalance;

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
                  _sectionHeader('РАСПРЕДЕЛЕНИЕ ОСТАТКА'),
                  const SizedBox(height: 8),
                  Text(
                    'Остаток к распределению в этом месяце: ${currentMonthSurplus.toInt()} ₽',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 9,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _budgetSlider(
                    label: 'КОШЕЛЕК',
                    value: _walletAlloc,
                    max: currentMonthSurplus,
                    onChanged: (val) {
                      double remaining =
                          currentMonthSurplus -
                          _deferredAlloc -
                          _mandatoryAlloc;
                      setState(() => _walletAlloc = val.clamp(0, remaining));
                    },
                  ),
                  _budgetSlider(
                    label: 'ОТЛОЖЕННЫЕ',
                    value: _deferredAlloc,
                    max: currentMonthSurplus,
                    onChanged: (val) {
                      double remaining =
                          currentMonthSurplus - _walletAlloc - _mandatoryAlloc;
                      setState(() => _deferredAlloc = val.clamp(0, remaining));
                    },
                  ),
                  _budgetSlider(
                    label: 'ОБЯЗАТЕЛЬНЫЕ',
                    value: _mandatoryAlloc,
                    max: currentMonthSurplus,
                    onChanged: (val) {
                      double remaining =
                          currentMonthSurplus - _walletAlloc - _deferredAlloc;
                      setState(() => _mandatoryAlloc = val.clamp(0, remaining));
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ИТОГО РАСПРЕДЕЛЕНО:',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${(_walletAlloc + _deferredAlloc + _mandatoryAlloc).toInt()} ₽',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 9,
                            color:
                                (_walletAlloc +
                                        _deferredAlloc +
                                        _mandatoryAlloc) >
                                    currentMonthSurplus
                                ? Colors.redAccent
                                : Colors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _applyButton(state, currentMonthSurplus),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        'Press Start 2P',
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _budgetSlider({
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
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
                fontSize: 9,
                color: Colors.white70,
              ),
            ),
            Text(
              '${value.toInt()} ₽',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 9,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: null,
          activeColor: Colors.cyanAccent,
          onChanged: (val) {
            double snapped = (val / 500).round() * 500.0;
            if ((max - val).abs() < 250) {
              snapped = max;
            } else {
              snapped = snapped.clamp(0.0, max);
            }
            onChanged(snapped);
          },
        ),
      ],
    );
  }

  Widget _applyButton(GameState state, double currentMonthSurplus) {
    double totalAllocated = _walletAlloc + _deferredAlloc + _mandatoryAlloc;
    bool isFullyAllocated = (totalAllocated - currentMonthSurplus).abs() < 0.1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFullyAllocated ? Colors.cyanAccent : Colors.grey,
              foregroundColor: Colors.black,
              side: isFullyAllocated ? const BorderSide(color: Colors.white, width: 2) : null,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: isFullyAllocated
                ? () {
                    state.updateDistribution(
                      _walletAlloc,
                      _deferredAlloc,
                      _mandatoryAlloc,
                    );
                    Navigator.pop(context);
                  }
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ПРИМЕНИТЬ ИЗМЕНЕНИЯ',
                  style: GoogleFonts.getFont('Press Start 2P', fontSize: 10),
                ),
                if (!isFullyAllocated)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'РАСПРЕДЕЛИТЕ ВЕСЬ БЮДЖЕТ',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 8,
                        color: Colors.black54,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
