

class FinanceManager {
  double walletBalance = 0;
  double deferredFund = 0;
  double mandatoryBalance = 0;
  double savingsGoal = 0;

  double walletAlloc = 10000;
  double deferredAlloc = 5000;
  double mandatoryAlloc = 15000;

  void resetBalances() {
    walletBalance = 0;
    deferredFund = 0;
    mandatoryBalance = 0;
    savingsGoal = 0;
  }

  void updateDistribution(double wallet, double deferred, double mandatory) {
    walletAlloc = wallet;
    deferredAlloc = deferred;
    mandatoryAlloc = mandatory;

    double currentTotal = walletBalance + deferredFund + mandatoryBalance;
    if (currentTotal > 0) {
      double totalAlloc = walletAlloc + deferredAlloc + mandatoryAlloc;
      if (totalAlloc > 0) {
        walletBalance = currentTotal * (walletAlloc / totalAlloc);
        deferredFund = currentTotal * (deferredAlloc / totalAlloc);
        mandatoryBalance = currentTotal * (mandatoryAlloc / totalAlloc);
      }
    }
  }

  double getTotalMoney() => walletBalance + deferredFund + mandatoryBalance + savingsGoal;

  Map<String, dynamic> toJson() => {
        'walletBalance': walletBalance,
        'deferredFund': deferredFund,
        'mandatoryBalance': mandatoryBalance,
        'savingsGoal': savingsGoal,
        'walletAlloc': walletAlloc,
        'deferredAlloc': deferredAlloc,
        'mandatoryAlloc': mandatoryAlloc,
      };

  void fromJson(Map<String, dynamic> json) {
    walletBalance = json['walletBalance']?.toDouble() ?? 0;
    deferredFund = json['deferredFund']?.toDouble() ?? 0;
    mandatoryBalance = json['mandatoryBalance']?.toDouble() ?? 0;
    savingsGoal = json['savingsGoal']?.toDouble() ?? 0;
    walletAlloc = json['walletAlloc']?.toDouble() ?? 10000;
    deferredAlloc = json['deferredAlloc']?.toDouble() ?? 5000;
    mandatoryAlloc = json['mandatoryAlloc']?.toDouble() ?? 15000;
  }
}
