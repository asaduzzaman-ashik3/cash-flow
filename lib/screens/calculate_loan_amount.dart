import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateLoanAmount extends StatefulWidget {
  const CalculateLoanAmount({super.key});

  @override
  State<CalculateLoanAmount> createState() => _CalculateLoanAmountState();
}

class _CalculateLoanAmountState extends State<CalculateLoanAmount> {
  String _loadAffordability = '0';
  String _netEarning = '0';
  double _repaymentCapacity = 0.0; // E value
  int? _selectedLoanTermMonths; // N value
  final double _yearlyInterestRate = 1.2; // Fixed 1.2% yearly interest
  String _calculatedLoanAmount = '0';
  
  // Loan term options: 6 months to 60 months (5 years)
  final List<int> _loanTermOptions = [6, 12, 18, 24, 30, 36, 42, 48, 54, 60];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedValues();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadSavedValues();
  }

  Future<void> loadSavedValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final netEarning = prefs.getDouble('net_earning') ?? 0.0;
      final loanAffordability = prefs.getDouble('loan_affordability') ?? 0.0;
      _repaymentCapacity = loanAffordability; // E = Loan Repayment Capacity (40% of net earning)
      
      // Load saved N value
      final savedN = prefs.getString('loan_term_months');
      final savedCalculatedAmount = prefs.getString('calculated_loan_amount');

      debugPrint('Loaded net_earning: $netEarning');
      debugPrint('Loaded loan_affordability: $loanAffordability');

      if (!mounted) return;

      // Validate saved N value - must be in the valid options list
      int? validatedN;
      if (savedN != null) {
        final parsedN = int.tryParse(savedN);
        if (parsedN != null && _loanTermOptions.contains(parsedN)) {
          validatedN = parsedN;
        }
      }

      setState(() {
        _netEarning = _formatNumber(netEarning);
        _loadAffordability = _formatNumber(loanAffordability);
        _selectedLoanTermMonths = validatedN;
        _calculatedLoanAmount = savedCalculatedAmount ?? '0';
        
        // Auto-calculate if N is selected and valid
        if (_selectedLoanTermMonths != null && _repaymentCapacity > 0) {
          _calculateLoanAmount();
        }
      });
    } catch (e) {
      debugPrint('Error loading values: $e');
    }
  }

  void _calculateLoanAmount() {
    if (_selectedLoanTermMonths == null || _repaymentCapacity <= 0) {
      return;
    }

    try {
      final E = _repaymentCapacity; // Loan Repayment Capacity
      final n = _selectedLoanTermMonths!.toDouble(); // n = N (Number of Installments)
      final N = _selectedLoanTermMonths!.toDouble(); // Loan Term in months
      final r = _yearlyInterestRate; // Fixed 1.2% yearly

      // Formula: A = (E × n) / (1 + r/100)^N
      final numerator = E * n;
      final denominator = pow(1 + (r / 100), N);
      final loanAmount = numerator / denominator;

      setState(() {
        _calculatedLoanAmount = _formatNumber(loanAmount);
      });

      // Save to SharedPreferences
      _saveCalculatedAmount(loanAmount);
    } catch (e) {
      debugPrint('Error calculating: $e');
    }
  }

  double pow(double base, double exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent.toInt(); i++) {
      result *= base;
    }
    return result;
  }

  Future<void> _saveCalculatedAmount(double loanAmount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loan_term_months', _selectedLoanTermMonths.toString());
      await prefs.setString('calculated_loan_amount', loanAmount.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loan amount calculated and saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving calculated amount: $e');
    }
  }

  void _onLoanTermChanged(int? value) {
    setState(() {
      _selectedLoanTermMonths = value;
    });
    if (value != null && _repaymentCapacity > 0) {
      _calculateLoanAmount();
    }
  }

  String _getLoanTermLabel(int months) {
    if (months < 12) {
      return '$months Month${months > 1 ? 's' : ''}';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years Year${years > 1 ? 's' : ''}';
      } else {
        return '$years Year${years > 1 ? 's' : ''} $remainingMonths Month${remainingMonths > 1 ? 's' : ''}';
      }
    }
  }

  String _formatNumber(double value) {
    if (value == 0.0) return "0";
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculate Loan Amount")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formula Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Formula: A = (E × n) / (1 + r/100)^N',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Where:\n'
                      'A = Loan Amount\n'
                      'E = Loan Repayment Capacity (40% of Net Earning)\n'
                      'n = Number of Installments (n = N)\n'
                      'N = Loan Term (Months)\n'
                      'r = Interest Rate (1.2% yearly)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Net Earning Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Net Earning:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '৳ $_netEarning',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Loan Repayment Capacity (E) Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Loan Repayment Capacity (E):',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '৳ $_loadAffordability',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Interest Rate Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Yearly Interest Rate (r):',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${_yearlyInterestRate}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Loan Term Dropdown
              DropdownButtonFormField<int>(
                value: _selectedLoanTermMonths,
                decoration: InputDecoration(
                  labelText: 'Loan Term (N)',
                  hintText: 'Select loan term',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                items: _loanTermOptions.map((int months) {
                  return DropdownMenuItem<int>(
                    value: months,
                    child: Text(_getLoanTermLabel(months)),
                  );
                }).toList(),
                onChanged: _onLoanTermChanged,
              ),
              const SizedBox(height: 12),
              
              // n value display (same as N)
              if (_selectedLoanTermMonths != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Number of Installments (n): ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${_selectedLoanTermMonths}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              
              // Calculated Loan Amount Display
              if (_selectedLoanTermMonths != null && _calculatedLoanAmount != "0")
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculated Loan Amount (A):',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '৳ $_calculatedLoanAmount',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
