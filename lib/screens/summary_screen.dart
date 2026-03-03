import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.isWin ? 'ПОБЕДА!' : 'МЕСЯЦ ЗАВЕРШЕН',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 24,
                      color: state.isWin
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildStatRow(
                    'ВСЕГО ДЕНЕГ',
                    '${state.totalMoney.toStringAsFixed(0)} ₽',
                  ),
                  _buildStatRow(
                    ' - КОШЕЛЕК',
                    '${state.walletBalance.toStringAsFixed(0)} ₽',
                  ),
                  _buildStatRow(
                    ' - ПОДУШКА',
                    '${state.emergencyFund.toStringAsFixed(0)} ₽',
                  ),
                  _buildStatRow(
                    ' - КОПИЛКА',
                    '${state.savingsGoal.toStringAsFixed(0)} ₽',
                  ),
                  const SizedBox(height: 10),
                  _buildStatRow('НАСТРОЕНИЕ', '${state.mood.toInt()}%'),
                  _buildStatRow('МЕРЧ', '${state.inventory.length} шт.'),
                  _buildStatRow('БАЛЛЫ', '${state.gamePoints}'),
                  const SizedBox(height: 40),
                  if (state.isWin)
                    const Text(
                      'ВЫ ДОСТИГЛИ СВОЕЙ ЦЕЛИ!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.cyanAccent),
                    )
                  else
                    const Text(
                      'ПОПРОБУЙТЕ ЕЩЕ РАЗ В СЛЕДУЮЩЕМ МЕСЯЦЕ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                      ),
                      onPressed: () {
                        state.startNewMonth(
                          state.selectedJob?.salary ?? 35000,
                          5000,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/game',
                          (route) => false,
                        );
                      },
                      child: const Text('НАЧАТЬ НОВЫЙ МЕСЯЦ'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    child: const Text(
                      'В ГЛАВНОЕ МЕНЮ',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
