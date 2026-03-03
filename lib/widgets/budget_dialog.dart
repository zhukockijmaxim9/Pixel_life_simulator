import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetDialog extends StatefulWidget {
  final double totalToDistribute;
  final Function({
    required double toWallet,
    required double toEmergency,
    required double toSavings,
  })
  onDistribute;

  const BudgetDialog({
    super.key,
    required this.totalToDistribute,
    required this.onDistribute,
  });

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late double _wallet;
  late double _emergency;
  late double _savings;

  @override
  void initState() {
    super.initState();
    // Default: 50% wallet, 30% emergency, 20% savings
    _wallet = widget.totalToDistribute * 0.5;
    _emergency = widget.totalToDistribute * 0.3;
    _savings = widget.totalToDistribute * 0.2;
  }

  void _adjust(String account, double delta) {
    setState(() {
      if (account == 'wallet') {
        if (_wallet + delta >= 0 &&
            _emergency - delta / 2 >= 0 &&
            _savings - delta / 2 >= 0) {
          _wallet += delta;
          _emergency -= delta / 2;
          _savings -= delta / 2;
        }
      } else if (account == 'emergency') {
        if (_emergency + delta >= 0 && _wallet - delta >= 0) {
          _emergency += delta;
          _wallet -= delta;
        }
      } else if (account == 'savings') {
        if (_savings + delta >= 0 && _wallet - delta >= 0) {
          _savings += delta;
          _wallet -= delta;
        }
      }

      // Normalize to ensure sum is exactly total
      double currentSum = _wallet + _emergency + _savings;
      if (currentSum != widget.totalToDistribute) {
        double diff = widget.totalToDistribute - currentSum;
        _wallet += diff;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 4),
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        'РАСПРЕДЕЛЕНИЕ БЮДЖЕТА',
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: 12,
          color: Colors.cyanAccent,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ДОСТУПНО: ${widget.totalToDistribute.toStringAsFixed(0)} ₽',
            style: const TextStyle(fontSize: 10, color: Colors.yellowAccent),
          ),
          const SizedBox(height: 20),
          _accountRow('КОШЕЛЕК', _wallet, (d) => _adjust('wallet', d)),
          _accountRow('ПОДУШКА', _emergency, (d) => _adjust('emergency', d)),
          _accountRow('КОПИЛКА', _savings, (d) => _adjust('savings', d)),
          const SizedBox(height: 10),
          const Text(
            'Баллансируйте суммы кнопками 👍',
            style: TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onDistribute(
              toWallet: _wallet,
              toEmergency: _emergency,
              toSavings: _savings,
            );
          },
          child: const Text('ГОТОВО'),
        ),
      ],
    );
  }

  Widget _accountRow(String label, double value, Function(double) onAdjust) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8)),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () => onAdjust(-1000),
              ),
              Expanded(
                child: Text(
                  '${value.toStringAsFixed(0)} ₽',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.greenAccent,
                ),
                onPressed: () => onAdjust(1000),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
