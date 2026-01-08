import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _calculatedLoanAmount = '0';
  
  // Text controllers for user inputs
  final TextEditingController _loanTermController = TextEditingController();
  final TextEditingController _numberOfInstallmentsController = TextEditingController();
  final TextEditingController _yearlyInterestRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to trigger calculation when inputs change
    _loanTermController.addListener(_onInputChanged);
    _numberOfInstallmentsController.addListener(_onInputChanged);
    _yearlyInterestRateController.addListener(_onInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedValues();
    });
  }

  @override
  void dispose() {
    _loanTermController.dispose();
    _numberOfInstallmentsController.dispose();
    _yearlyInterestRateController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (_repaymentCapacity > 0) {
      _calculateLoanAmount();
    }
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
      _repaymentCapacity = loanAffordability; // E = Loan Repayment Capacity (50% of net earning)
      
      // Load saved values
      final savedLoanTerm = prefs.getString('loan_term_months');
      final savedNumberOfInstallments = prefs.getString('number_of_installments');
      final savedInterestRate = prefs.getString('yearly_interest_rate');
      final savedCalculatedAmount = prefs.getString('calculated_loan_amount');

      debugPrint('Loaded net_earning: $netEarning');
      debugPrint('Loaded loan_affordability: $loanAffordability');

      if (!mounted) return;

      setState(() {
        _netEarning = netEarning > 0 ? _formatNumber(netEarning) : "Not Available";
        _loadAffordability = loanAffordability > 0 ? _formatNumber(loanAffordability) : "Not Available";
        _calculatedLoanAmount = savedCalculatedAmount ?? '0';
        
        // Load saved input values
        _loanTermController.text = savedLoanTerm ?? '';
        _numberOfInstallmentsController.text = savedNumberOfInstallments ?? '';
        _yearlyInterestRateController.text = savedInterestRate ?? '1.2';
        
        // Auto-calculate if values are available
        if (_repaymentCapacity > 0) {
          _calculateLoanAmount();
        }
      });
    } catch (e) {
      debugPrint('Error loading values: $e');
    }
  }

  void _calculateLoanAmount() {
    if (_repaymentCapacity <= 0) {
      return;
    }

    try {
      // Get user input values
      final nValue = _numberOfInstallmentsController.text.trim();
      final rValue = _yearlyInterestRateController.text.trim();
      final nTermValue = _loanTermController.text.trim();
      
      if (nValue.isEmpty || rValue.isEmpty || nTermValue.isEmpty) {
        setState(() {
          _calculatedLoanAmount = '0';
        });
        return;
      }

      final E = _repaymentCapacity; // Loan Repayment Capacity
      final n = double.tryParse(nValue) ?? 0.0; // Number of Installments (user input)
      final N = double.tryParse(nTermValue) ?? 0.0; // Loan Term in months (user input)
      final r = double.tryParse(rValue) ?? 0.0; // Yearly Interest Rate (user input)

      if (n <= 0 || N <= 0 || r < 0) {
        setState(() {
          _calculatedLoanAmount = '0';
        });
        return;
      }

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
      setState(() {
        _calculatedLoanAmount = '0';
      });
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
      await prefs.setString('loan_term_months', _loanTermController.text);
      await prefs.setString('number_of_installments', _numberOfInstallmentsController.text);
      await prefs.setString('yearly_interest_rate', _yearlyInterestRateController.text);
      await prefs.setString('calculated_loan_amount', loanAmount.toString());
    } catch (e) {
      debugPrint('Error saving calculated amount: $e');
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
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal[200]!),
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
                      'E = Loan Repayment Capacity (50% of Net Earning)\n'
                      'n = Number of Installments (User Input)\n'
                      'N = Loan Term in Months (User Input)\n'
                      'r = Yearly Interest Rate (User Input)',
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
                padding: const EdgeInsets.all( 12),
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
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      _netEarning != "Not Available" ? '৳ $_netEarning' : _netEarning,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Loan Repayment Capacity (E) Display
              Container(
                padding: const EdgeInsets.all(12),
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
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      _loadAffordability != "Not Available" ? '৳ $_loadAffordability' : _loadAffordability,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Loan Term Input Field
              TextField(
                controller: _loanTermController,
                keyboardType: TextInputType.number,
                inputFormatters:  [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Loan Term (N) - Months',
                  hintText: 'Enter loan term in months',
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
                onChanged: (_) => _calculateLoanAmount(),
              ),
              const SizedBox(height: 12),
              
              // Number of Installments Input Field
              TextField(
                controller: _numberOfInstallmentsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Number of Installments (n)',
                  hintText: 'Enter number of installments',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.auto_fix_high),
                    tooltip: 'Use loan term value',
                    onPressed: () {
                      if (_loanTermController.text.isNotEmpty) {
                        _numberOfInstallmentsController.text = _loanTermController.text;
                        _calculateLoanAmount();
                      }
                    },
                  ),
                ),
                onChanged: (_) => _calculateLoanAmount(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _yearlyInterestRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Yearly Interest Rate (r) %',
                  hintText: 'Enter yearly interest rate (e.g., 1.2)',
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
                onChanged: (_) => _calculateLoanAmount(),
              ),
              const SizedBox(height: 20),
              
              // Calculated Loan Amount Display
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _calculatedLoanAmount != "0" ? Colors.teal[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _calculatedLoanAmount != "0" 
                          ? Colors.teal[300]!
                          : Colors.grey[300]!,
                    ),
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
                        _calculatedLoanAmount != "0" 
                            ? '৳ $_calculatedLoanAmount'
                            : 'Not Available',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _calculatedLoanAmount != "0" 
                              ? Colors.teal
                              : Colors.grey,
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
