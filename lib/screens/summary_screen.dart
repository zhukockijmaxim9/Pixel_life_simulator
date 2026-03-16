import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../ui_theme.dart';

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
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return AppColors.gradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                    },
                    child: Text(
                      state.isWin
                          ? 'ЦЕЛЬ ДОСТИГНУТА!'
                          : (state.mood <= 0
                                ? 'ИГРА ОКОНЧЕНА'
                                : 'МЕСЯЦ ЗАВЕРШЕН'),
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Месяц ${state.currentMonth}',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 14,
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
                    ' - ОТЛОЖЕННЫЕ',
                    '${state.deferredFund.toStringAsFixed(0)} ₽',
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
                            fontSize: 11,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradient,
                    ),
                    child: Icon(
                      state.isWin
                          ? Icons.emoji_events
                          : (state.mood <= 0 ? Icons.warning : Icons.trending_down),
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    state.isWin
                        ? 'Отлично! Вы накопили на цель. Можно выбрать новую!'
                        : (state.mood <= 0
                              ? 'ВЫГОРАНИЕ! 💀\nВаше настроение упало до нуля. Психологическое состояние не позволяет продолжать.'
                              : 'ЦЕЛЬ НЕ ДОСТИГНУТА! 📉\nВам не хватило накоплений до цели. Планируйте бюджет тщательнее!'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  if (state.isWin && state.mood < 60)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '💡 СОВЕТ: Для повышения в должности нужно иметь настроение выше 60%!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Press Start 2P',
                          fontSize: 8,
                          color: Colors.orangeAccent,
                          height: 1.4,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Next month → re-planning flow
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: state.isWin ? AppColors.gradient : AppColors.greyPinkGradient,
                        ),
                        child: TextButton(
                          onPressed: () {
                          if (state.isWin) {
                            // Success -> Move to next month
                            final currentJob = state.selectedJob;
                            final hasNew = state.hasNewJobOpportunities;
                            
                            state.startNewMonth();
                            
                            if (hasNew) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/job_select',
                              );
                            } else {
                              // Skip job selection, go straight to planning with current job
                              Navigator.pushReplacementNamed(
                                context,
                                '/planning',
                                arguments: currentJob,
                              );
                            }
                          } else {
                            // Failure -> Restart from month 1 (Main Menu)
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (r) => false,
                            );
                          }
                          },
                          child: Text(
                            state.isWin
                                ? 'СЛЕДУЮЩИЙ МЕСЯЦ ➔'
                                : 'ПОПРОБОВАТЬ СНОВА ↻',
                            style: GoogleFonts.getFont(
                              'Press Start 2P',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
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
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
