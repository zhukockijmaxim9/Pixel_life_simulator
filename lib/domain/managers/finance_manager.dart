

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
}
