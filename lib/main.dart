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

      final food = double.tryParse(prefs.getString('expense_food') ?? '') ?? 0.0;
      final houseRent = double.tryParse(prefs.getString('expense_house_rent') ?? '') ?? 0.0;
      final loanInstallment = double.tryParse(prefs.getString('expense_loan_installment') ?? '') ?? 0.0;
      final dps = double.tryParse(prefs.getString('expense_dps') ?? '') ?? 0.0;
      final clothingPurchase = double.tryParse(prefs.getString('expense_clothing_purchase') ?? '') ?? 0.0;
      final medical = double.tryParse(prefs.getString('expense_medical') ?? '') ?? 0.0;
      final education = double.tryParse(prefs.getString('expense_education') ?? '') ?? 0.0;
      final electricityBill = double.tryParse(prefs.getString('expense_electricity_bill') ?? '') ?? 0.0;
      final fuelCost = double.tryParse(prefs.getString('expense_fuel_cost') ?? '') ?? 0.0;
      final transportationCost = double.tryParse(prefs.getString('expense_transportation_cost') ?? '') ?? 0.0;
      final mobileInternetBill = double.tryParse(prefs.getString('expense_mobile_internet_bill') ?? '') ?? 0.0;
      final houseRepair = double.tryParse(prefs.getString('expense_house_repair') ?? '') ?? 0.0;
      final landTax = double.tryParse(prefs.getString('expense_land_tax') ?? '') ?? 0.0;
      final festival = double.tryParse(prefs.getString('expense_festival') ?? '') ?? 0.0;
      final dishBill = double.tryParse(prefs.getString('expense_dish_bill') ?? '') ?? 0.0;
      final generatorBill = double.tryParse(prefs.getString('expense_generator_bill') ?? '') ?? 0.0;
      final domesticWorkerSalary = double.tryParse(prefs.getString('expense_domestic_worker_salary') ?? '') ?? 0.0;
      final serviceCharge = double.tryParse(prefs.getString('expense_service_charge') ?? '') ?? 0.0;
      final garbageBill = double.tryParse(prefs.getString('expense_garbage_bill') ?? '') ?? 0.0;
      final others = double.tryParse(prefs.getString('expense_others') ?? '') ?? 0.0;

      total = food +
          houseRent +
          loanInstallment +
          dps +
          clothingPurchase +
          medical +
          education +
          electricityBill +
          fuelCost +
          transportationCost +
          mobileInternetBill +
          houseRepair +
          landTax +
          festival +
          dishBill +
          generatorBill +
          domesticWorkerSalary +
          serviceCharge +
          garbageBill +
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
