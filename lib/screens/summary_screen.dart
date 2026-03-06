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
                    state.isWin
                        ? 'ЦЕЛЬ ДОСТИГНУТА!'
                        : (state.mood <= 0
                              ? 'ИГРА ОКОНЧЕНА'
                              : 'МЕСЯЦ ЗАВЕРШЕН'),
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 16,
                      color: state.isWin
                          ? Colors.greenAccent
                          : (state.mood <= 0
                                ? Colors.redAccent
                                : Colors.yellowAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Месяц ${state.currentMonth}',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                    ' - ОБЯЗАТЕЛЬНЫЕ',
                    '${state.mandatoryBalance.toStringAsFixed(0)} ₽',
                  ),
                  _buildStatRow(
                    ' - КОПИЛКА',
                    '${state.savingsGoal.toStringAsFixed(0)} ₽',
                  ),
                  const SizedBox(height: 10),
                  _buildStatRow('НАСТРОЕНИЕ', '${state.mood.toInt()}%'),
                  _buildStatRow('БАЛЛЫ', '${state.gamePoints}'),

                  if (state.isWin && state.selectedGoal != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.greenAccent.withValues(alpha: 0.1),
                        child: Text(
                          '🎉 Цель "${state.selectedGoal!.title}" выполнена!\n+${state.selectedGoal!.pointsReward} баллов для мерча',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 8,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  Icon(
                    state.isWin
                        ? Icons.sentiment_very_satisfied
                        : Icons.sentiment_satisfied_alt,
                    size: 80,
                    color: state.isWin
                        ? Colors.greenAccent
                        : Colors.yellowAccent,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    state.isWin
                        ? 'Отлично! Вы накопили на цель. Можно выбрать новую!'
                        : (state.mood <= 0
                              ? 'Вы полностью выгорели. Ваше психологическое состояние не позволяет продолжать.'
                              : 'Вам не хватило накоплений до цели. Планируйте бюджет тщательнее!'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 8,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // Next month → re-planning flow
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (state.mood > 0) {
                          state.startNewMonth();
                          Navigator.pushReplacementNamed(
                            context,
                            '/job_select',
                          );
                        } else {
                          // Loss case (burnout)
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (r) => false,
                          );
                        }
                      },
                      child: Text(
                        state.mood > 0
                            ? 'СЛЕДУЮЩИЙ МЕСЯЦ'
                            : 'ПОПРОБОВАТЬ СНОВА',
                        style: GoogleFonts.getFont(
                          'Press Start 2P',
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
