import 'package:cash_flow/screens/add_cash_in.dart';
import 'package:cash_flow/screens/add_cash_out.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/stat_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Cash Flow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _totalEarn = "0";
  String _totalExpense = "0";
  String _netEarning = "0";

  @override
  void initState() {
    super.initState();
    _loadAllTotals();
  }

  Future<void> _loadAllTotals() async {
    final totalEarn = await _calculateTotalEarn();
    final totalExpense = await _calculateTotalExpense();
    final netEarning = totalEarn - totalExpense;
    
    if (mounted) {
      setState(() {
        _totalEarn = _formatNumber(totalEarn);
        _totalExpense = _formatNumber(totalExpense);
        _netEarning = _formatNumber(netEarning);
      });
    }
  }

  Future<double> _calculateTotalEarn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double total = 0.0;

      // Get all 12 cash-in values and sum them
      final ownSalary = double.tryParse(prefs.getString('own_salary') ?? '') ?? 0.0;
      final husbandWifeSalary = double.tryParse(prefs.getString('husband_wife_salary') ?? '') ?? 0.0;
      final sonDaughterSalary = double.tryParse(prefs.getString('son_daughter_salary') ?? '') ?? 0.0;
      final fatherMotherSalary = double.tryParse(prefs.getString('father_mother_salary') ?? '') ?? 0.0;
      final savingsEarn = double.tryParse(prefs.getString('savings_earn') ?? '') ?? 0.0;
      final homeRentEarn = double.tryParse(prefs.getString('home_rent_earn') ?? '') ?? 0.0;
      final businessEarn = double.tryParse(prefs.getString('business_earn') ?? '') ?? 0.0;
      final agricultureEarn = double.tryParse(prefs.getString('agriculture_earn') ?? '') ?? 0.0;
      final animalIncreasingEarn = double.tryParse(prefs.getString('animal_increasing_earn') ?? '') ?? 0.0;
      final treeSellsEarn = double.tryParse(prefs.getString('tree_sells_earn') ?? '') ?? 0.0;
      final fruitSellEarn = double.tryParse(prefs.getString('fruit_sell_earn') ?? '') ?? 0.0;
      final others = double.tryParse(prefs.getString('others') ?? '') ?? 0.0;

      total = ownSalary +
          husbandWifeSalary +
          sonDaughterSalary +
          fatherMotherSalary +
          savingsEarn +
          homeRentEarn +
          businessEarn +
          agricultureEarn +
          animalIncreasingEarn +
          treeSellsEarn +
          fruitSellEarn +
          others;

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> _calculateTotalExpense() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double total = 0.0;

      // Get all 20 cash-out values and sum them
      final foodGroceries = double.tryParse(prefs.getString('expense_food_groceries') ?? '') ?? 0.0;
      final utilities = double.tryParse(prefs.getString('expense_utilities') ?? '') ?? 0.0;
      final rentMortgage = double.tryParse(prefs.getString('expense_rent_mortgage') ?? '') ?? 0.0;
      final transportation = double.tryParse(prefs.getString('expense_transportation') ?? '') ?? 0.0;
      final healthcare = double.tryParse(prefs.getString('expense_healthcare') ?? '') ?? 0.0;
      final education = double.tryParse(prefs.getString('expense_education') ?? '') ?? 0.0;
      final clothing = double.tryParse(prefs.getString('expense_clothing') ?? '') ?? 0.0;
      final entertainment = double.tryParse(prefs.getString('expense_entertainment') ?? '') ?? 0.0;
      final insurance = double.tryParse(prefs.getString('expense_insurance') ?? '') ?? 0.0;
      final loanPayments = double.tryParse(prefs.getString('expense_loan_payments') ?? '') ?? 0.0;
      final homeMaintenance = double.tryParse(prefs.getString('expense_home_maintenance') ?? '') ?? 0.0;
      final personalCare = double.tryParse(prefs.getString('expense_personal_care') ?? '') ?? 0.0;
      final communication = double.tryParse(prefs.getString('expense_communication') ?? '') ?? 0.0;
      final shopping = double.tryParse(prefs.getString('expense_shopping') ?? '') ?? 0.0;
      final travel = double.tryParse(prefs.getString('expense_travel') ?? '') ?? 0.0;
      final giftsDonations = double.tryParse(prefs.getString('expense_gifts_donations') ?? '') ?? 0.0;
      final taxes = double.tryParse(prefs.getString('expense_taxes') ?? '') ?? 0.0;
      final childcare = double.tryParse(prefs.getString('expense_childcare') ?? '') ?? 0.0;
      final petCare = double.tryParse(prefs.getString('expense_pet_care') ?? '') ?? 0.0;
      final others = double.tryParse(prefs.getString('expense_others') ?? '') ?? 0.0;

      total = foodGroceries +
          utilities +
          rentMortgage +
          transportation +
          healthcare +
          education +
          clothing +
          entertainment +
          insurance +
          loanPayments +
          homeMaintenance +
          personalCare +
          communication +
          shopping +
          travel +
          giftsDonations +
          taxes +
          childcare +
          petCare +
          others;

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: [
              StatCard(
                title: "Total Earn",
                value: _totalEarn,
                color: Colors.green,
                icon: Icons.attach_money,
              ),
              StatCard(
                title: "Total Expense",
                value: _totalExpense,
                color: Colors.red,
                icon: Icons.money_off,
              ),
              StatCard(
                title: "Net Earning",
                value: _netEarning,
                color: Colors.orange,
                icon: Icons.trending_up,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddCashIn()),
                        );
                        // Refresh all totals when returning from AddCashIn
                        _loadAllTotals();
                      },
                      child: Text("Add Cash In Flow"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddCashOut()),
                        );
                        // Refresh totals when returning from AddCashOut
                        _loadAllTotals();
                      },
                      child: Text("Add Cash Out Flow"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
