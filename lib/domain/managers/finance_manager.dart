

class FinanceManager {
  double walletBalance = 0;
  double emergencyFund = 0;
  double mandatoryBalance = 0;
  double savingsGoal = 0;

  double walletAlloc = 10000;
  double emergencyAlloc = 5000;
  double mandatoryAlloc = 15000;

  void resetBalances() {
    walletBalance = 0;
    emergencyFund = 0;
    mandatoryBalance = 0;
    savingsGoal = 0;
  }

  void updateDistribution(double wallet, double emergency, double mandatory) {
    walletAlloc = wallet;
    emergencyAlloc = emergency;
    mandatoryAlloc = mandatory;

    double currentTotal = walletBalance + emergencyFund + mandatoryBalance;
    if (currentTotal > 0) {
      double totalAlloc = walletAlloc + emergencyAlloc + mandatoryAlloc;
      if (totalAlloc > 0) {
        walletBalance = currentTotal * (walletAlloc / totalAlloc);
        emergencyFund = currentTotal * (emergencyAlloc / totalAlloc);
        mandatoryBalance = currentTotal * (mandatoryAlloc / totalAlloc);
      }
    }
  }

  double getTotalMoney() => walletBalance + emergencyFund + mandatoryBalance + savingsGoal;
}
