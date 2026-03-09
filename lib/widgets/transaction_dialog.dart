import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../models/enums.dart';
import '../app_state.dart';

class TransactionDialog extends StatelessWidget {
  final PendingTransaction transaction;
  final GameState state;
  final VoidCallback onReallocate;

  const TransactionDialog({
    super.key,
    required this.transaction,
    required this.state,
    required this.onReallocate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 4),
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        "НЕДОСТАТОЧНО СРЕДСТВ",
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: 12,
          color: Colors.redAccent,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${transaction.title}: ${transaction.amount.toInt()} ₽",
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 10,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "На счету ${_accountName(transaction.primaryAccount)} не хватает ${transaction.deficit.toInt()} ₽.",
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 8,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "ВЫБЕРИТЕ СЧЕТ ДЛЯ СПИСАНИЯ ОСТАТКА:",
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 8,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 12),
          _accountButton(
            context,
            "КОШЕЛЕК",
            state.walletBalance,
            AccountType.wallet,
            Colors.yellowAccent,
          ),
          _accountButton(
            context,
            "ПОДУШКА",
            state.emergencyFund,
            AccountType.emergency,
            Colors.orangeAccent,
          ),
          _accountButton(
            context,
            "ОБЯЗАТЕЛЬНЫЕ",
            state.mandatoryBalance,
            AccountType.mandatory,
            Colors.lightBlueAccent,
          ),
          _accountButton(
            context,
            "ЦЕЛЬ",
            state.savingsGoal,
            AccountType.savings,
            Colors.cyanAccent,
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white24, thickness: 1),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.cyanAccent),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onReallocate,
              child: Text(
                "ПЕРЕРАСПРЕДЕЛИТЬ БЮДЖЕТ",
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 7,
                  color: Colors.cyanAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _accountName(AccountType type) {
    switch (type) {
      case AccountType.wallet:
        return "КОШЕЛЕК";
      case AccountType.emergency:
        return "ПОДУШКА";
      case AccountType.mandatory:
        return "ОБЯЗАТЕЛЬНЫЕ";
      case AccountType.savings:
        return "ЦЕЛЬ";
    }
  }

  Widget _accountButton(
    BuildContext context,
    String label,
    double balance,
    AccountType type,
    Color color,
  ) {
    bool canPay = balance >= transaction.deficit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canPay ? Colors.grey[850] : Colors.black,
            disabledBackgroundColor: Colors.black,
            side: BorderSide(
              color: canPay ? color.withValues(alpha: 0.5) : Colors.white12,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          onPressed: canPay
              ? () {
                  state.resolvePendingTransaction(type);
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 8,
                  color: canPay ? Colors.white : Colors.grey[700],
                ),
              ),
              Text(
                "${balance.toInt()} ₽",
                style: GoogleFonts.getFont(
                  'Press Start 2P',
                  fontSize: 8,
                  color: canPay ? color : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
