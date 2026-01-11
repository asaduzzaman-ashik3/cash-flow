import 'dart:ui';

import 'package:cash_flow/screens/add_cash_in.dart';
import 'package:cash_flow/screens/add_cash_out.dart';
import 'package:cash_flow/screens/calculate_loan_amount.dart';
import 'package:cash_flow/screens/cash_in_flow_details.dart';
import 'package:cash_flow/screens/cash_out_flow_details.dart';
import 'package:cash_flow/screens/net_earning_details.dart';
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
      home: const MyHomePage(title: 'Home'),
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
  String _loanRepaymentCapacity = "0";

  @override
  void initState() {
    super.initState();
    _loadAllTotals();
  }

  Future<void> _loadAllTotals() async {
    final totalEarn = await _calculateTotalEarn();
    final totalExpense = await _calculateTotalExpense();

    final netEarning = totalEarn - totalExpense;
    final loanRepaymentCapacity = netEarning * 0.4;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('net_earning', netEarning);
    await prefs.setDouble(
      'loan_affordability',
      loanRepaymentCapacity,
    ); // Save as E value

    // Get calculated loan amount if available
    final calculatedLoanAmount = prefs.getString('calculated_loan_amount');
    if (calculatedLoanAmount != null &&
        calculatedLoanAmount.isNotEmpty &&
        calculatedLoanAmount != '0') {}

    if (!mounted) return;

    setState(() {
      _totalEarn = totalEarn > 0 ? _formatNumber(totalEarn) : "Not Added";
      _totalExpense = totalExpense > 0
          ? _formatNumber(totalExpense)
          : "Not Added";
      _netEarning = netEarning > 0 ? _formatNumber(netEarning) : "Not Added";
      _loanRepaymentCapacity = loanRepaymentCapacity > 0
          ? _formatNumber(loanRepaymentCapacity)
          : "Not Added";
    });
  }

  Future<double> _calculateTotalEarn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double total = 0.0;

      // Get all 12 cash-in values and sum them
      final ownSalary =
          double.tryParse(prefs.getString('own_salary') ?? '') ?? 0.0;
      final husbandWifeSalary =
          double.tryParse(prefs.getString('husband_wife_salary') ?? '') ?? 0.0;
      final sonDaughterSalary =
          double.tryParse(prefs.getString('son_daughter_salary') ?? '') ?? 0.0;
      final fatherMotherSalary =
          double.tryParse(prefs.getString('father_mother_salary') ?? '') ?? 0.0;
      final savingsEarn =
          double.tryParse(prefs.getString('savings_earn') ?? '') ?? 0.0;
      final homeRentEarn =
          double.tryParse(prefs.getString('home_rent_earn') ?? '') ?? 0.0;
      final businessEarn =
          double.tryParse(prefs.getString('business_earn') ?? '') ?? 0.0;
      final agricultureEarn =
          double.tryParse(prefs.getString('agriculture_earn') ?? '') ?? 0.0;
      final animalIncreasingEarn =
          double.tryParse(prefs.getString('animal_increasing_earn') ?? '') ??
          0.0;
      final treeSellsEarn =
          double.tryParse(prefs.getString('tree_sells_earn') ?? '') ?? 0.0;
      final fruitSellEarn =
          double.tryParse(prefs.getString('fruit_sell_earn') ?? '') ?? 0.0;
      final others = double.tryParse(prefs.getString('others') ?? '') ?? 0.0;

      total =
          ownSalary +
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

      // Add dynamic cash in fields
      final dynamicFieldsJson =
          prefs.getStringList('dynamic_cash_in_fields') ?? [];
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          final value =
              double.tryParse(
                prefs.getString('dynamic_cash_in_field_$label') ?? '',
              ) ??
              0.0;
          total += value;
        }
      }

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> _calculateTotalExpense() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double total = 0.0;

      final food =
          double.tryParse(prefs.getString('expense_food') ?? '') ?? 0.0;
      final houseRent =
          double.tryParse(prefs.getString('expense_house_rent') ?? '') ?? 0.0;
      final loanInstallment =
          double.tryParse(prefs.getString('expense_loan_installment') ?? '') ??
          0.0;
      final dps = double.tryParse(prefs.getString('expense_dps') ?? '') ?? 0.0;
      final clothingPurchase =
          double.tryParse(prefs.getString('expense_clothing_purchase') ?? '') ??
          0.0;
      final medical =
          double.tryParse(prefs.getString('expense_medical') ?? '') ?? 0.0;
      final education =
          double.tryParse(prefs.getString('expense_education') ?? '') ?? 0.0;
      final electricityBill =
          double.tryParse(prefs.getString('expense_electricity_bill') ?? '') ??
          0.0;
      final fuelCost =
          double.tryParse(prefs.getString('expense_fuel_cost') ?? '') ?? 0.0;
      final transportationCost =
          double.tryParse(
            prefs.getString('expense_transportation_cost') ?? '',
          ) ??
          0.0;
      final mobileInternetBill =
          double.tryParse(
            prefs.getString('expense_mobile_internet_bill') ?? '',
          ) ??
          0.0;
      final houseRepair =
          double.tryParse(prefs.getString('expense_house_repair') ?? '') ?? 0.0;
      final landTax =
          double.tryParse(prefs.getString('expense_land_tax') ?? '') ?? 0.0;
      final festival =
          double.tryParse(prefs.getString('expense_festival') ?? '') ?? 0.0;
      final dishBill =
          double.tryParse(prefs.getString('expense_dish_bill') ?? '') ?? 0.0;
      final generatorBill =
          double.tryParse(prefs.getString('expense_generator_bill') ?? '') ??
          0.0;
      final domesticWorkerSalary =
          double.tryParse(
            prefs.getString('expense_domestic_worker_salary') ?? '',
          ) ??
          0.0;
      final serviceCharge =
          double.tryParse(prefs.getString('expense_service_charge') ?? '') ??
          0.0;
      final garbageBill =
          double.tryParse(prefs.getString('expense_garbage_bill') ?? '') ?? 0.0;
      final others =
          double.tryParse(prefs.getString('expense_others') ?? '') ?? 0.0;

      total =
          food +
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

      // Add dynamic cash out fields
      final dynamicFieldsJson =
          prefs.getStringList('dynamic_cash_out_fields') ?? [];
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          final value =
              double.tryParse(
                prefs.getString('dynamic_cash_out_field_$label') ?? '',
              ) ??
              0.0;
          total += value;
        }
      }

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  String _formatNumber(double number) {
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Function to get all expense data
  Future<Map<String, double>> _getAllExpenseData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, double> expenses = {};

      // Define all expense categories with their keys and display names
      final expenseCategories = {
        'expense_food': 'Food Expense',
        'expense_house_rent': 'House Rent',
        'expense_loan_installment': 'Loan Installment',
        'expense_dps': 'DPS',
      };

      // Load static expenses
      for (final entry in expenseCategories.entries) {
        final value = double.tryParse(prefs.getString(entry.key) ?? '') ?? 0.0;
        if (value > 0) { // Only add if there's a value
          expenses[entry.value] = value;
        }
      }

      // Load dynamic cash out fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_out_fields') ?? [];
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          final value = double.tryParse(prefs.getString('dynamic_cash_out_field_\$label') ?? '') ?? 0.0;
          if (value > 0) { // Only add if there's a value
            expenses[label] = value;
          }
        }
      }

      return expenses;
    } catch (e) {
      print('Error getting expense data: \$e');
      return {};
    }
  }

  // Function to get all cash in data
  Future<Map<String, double>> _getAllCashInData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, double> cashIns = {};

      // Define all cash in categories with their keys and display names
      final cashInCategories = {
        'own_salary': 'Own Salary',
        'husband_wife_salary': 'Spouse Salary',
        'son_daughter_salary': 'Child Salary',
        'father_mother_salary': 'Parent Salary',
      };

      // Load static cash in values
      for (final entry in cashInCategories.entries) {
        final value = double.tryParse(prefs.getString(entry.key) ?? '') ?? 0.0;
        if (value > 0) { // Only add if there's a value
          cashIns[entry.value] = value;
        }
      }

      // Load dynamic cash in fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_in_fields') ?? [];
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          final value = double.tryParse(prefs.getString('dynamic_cash_in_field_\$label') ?? '') ?? 0.0;
          if (value > 0) { // Only add if there's a value
            cashIns[label] = value;
          }
        }
      }

      return cashIns;
    } catch (e) {
      print('Error getting cash in data: \$e');
      return {};
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    switch (_currentIndex) {
      case 0: // Home
        currentScreen = SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 12,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF25B1E6),
                        Color(0xFFC868FD),
                        Color(0xFFFA9270),
                      ],
                    ),
                  ),
                  child: Column(
                    spacing: 5,
                    children: [
                      Text(
                        "Net Income",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _netEarning,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      // glass effect
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.trending_up_outlined,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cash In",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _totalEarn,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.trending_down_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cash Out",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _totalExpense,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Cash In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text("View All",style: TextStyle(color: Colors.grey), )
                  ],
                ),
                                
                // Individual cash in items
                FutureBuilder<Map<String, double>>(
                  future: _getAllCashInData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final cashIns = snapshot.data!;
                      return Column(
                        children: cashIns.entries.map((entry) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: StatCard(
                              title: entry.key,
                              value: _formatNumber(entry.value),
                              color: Colors.green,
                              icon: Icons.trending_up_outlined,
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return StatCard(
                        title: "Total Cash In",
                        value: _totalEarn,
                        color: Colors.green,
                        icon: Icons.trending_up_outlined,
                      );
                    }
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cash Out",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    Text("View All",style: TextStyle(color: Colors.grey), )
                  ],
                ),
                // Individual expense items
                FutureBuilder<Map<String, double>>(
                  future: _getAllExpenseData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final expenses = snapshot.data!;
                      return Column(
                        children: expenses.entries.map((entry) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: StatCard(
                              title: entry.key,
                              value: _formatNumber(entry.value),
                              color: Colors.red,
                              icon: Icons.trending_down_outlined,
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return StatCard(
                        title: "Total Cash Out",
                        value: _totalExpense,
                        color: Colors.red,
                        icon: Icons.trending_down_outlined,
                      );
                    }
                  },
                ),
                StatCard(
                  title: "Net Income",
                  value: _netEarning,
                  color: Colors.orange,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                StatCard(
                  title: "Loan Repayment Capacity",
                  value: _loanRepaymentCapacity,
                  color: Colors.cyan,
                  icon: Icons.payments_outlined,
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCashIn(),
                            ),
                          );
                          _loadAllTotals();
                        },
                        child: Center(
                          child: Row(
                            spacing: 3,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.add), Text("Add Cash In")],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCashOut(),
                            ),
                          );
                          _loadAllTotals();
                        },
                        child: Center(
                          child: Row(
                            spacing: 3,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.add), Text("Add Cash Out")],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await _loadAllTotals();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculateLoanAmount(),
                        ),
                      );
                      _loadAllTotals();
                    },
                    child: Center(
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate_outlined),
                          Text("Calculate Loan Amount"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 1: // Cash In Flow Details
        currentScreen = CashInFlowDetails();
        break;
      case 2: // Cash Out Flow Details
        currentScreen = CashOutFlowDetails();
        break;
      case 3: // Net Earning Details
        currentScreen = NetEarningDetails();
        break;
      default:
        currentScreen = SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 12,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CashInFlowDetails(),
                      ),
                    );
                  },
                  child: StatCard(
                    title: "Total Earn",
                    value: _totalEarn,
                    color: Colors.green,
                    icon: Icons.attach_money,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CashOutFlowDetails(),
                      ),
                    );
                  },
                  child: StatCard(
                    title: "Total Expense",
                    value: _totalExpense,
                    color: Colors.red,
                    icon: Icons.money_off,
                  ),
                ),
                InkWell(
                  child: StatCard(
                    title: "Net Earning",
                    value: _netEarning,
                    color: Colors.orange,
                    icon: Icons.trending_up,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NetEarningDetails(),
                      ),
                    );
                  },
                ),
                StatCard(
                  title: "Loan Repayment Capacity",
                  value: _loanRepaymentCapacity,
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
                            MaterialPageRoute(
                              builder: (context) => AddCashIn(),
                            ),
                          );
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
                            MaterialPageRoute(
                              builder: (context) => AddCashOut(),
                            ),
                          );
                          _loadAllTotals();
                        },
                        child: Text("Add Cash Out Flow"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _loadAllTotals();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculateLoanAmount(),
                        ),
                      );
                      // Refresh to show calculated loan amount
                      _loadAllTotals();
                    },
                    child: Text("Calculate Loan Amount"),
                  ),
                ),
              ],
            ),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _currentIndex == 0
              ? widget.title
              : [
                  'Home',
                  'Cash In Flow List',
                  'Cash Out Flow List',
                  'Net Income List',
                ][_currentIndex],
        ),
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            label: 'In List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down_outlined),
            label: 'Out List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Net List',
          ),
        ],
      ),
    );
  }
}
