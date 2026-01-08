import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashOutFlowDetails extends StatefulWidget {
  const CashOutFlowDetails({super.key});

  @override
  State<CashOutFlowDetails> createState() => _CashOutFlowDetailsState();
}

class _CashOutFlowDetailsState extends State<CashOutFlowDetails> {
  Map<String, String> _cashOutData = {};
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCashOutData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCashOutData();
  }

  Future<void> _loadCashOutData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final food = prefs.getString('expense_food') ?? '';
      final houseRent = prefs.getString('expense_house_rent') ?? '';
      final loanInstallment = prefs.getString('expense_loan_installment') ?? '';
      final dps = prefs.getString('expense_dps') ?? '';
      final clothingPurchase = prefs.getString('expense_clothing_purchase') ?? '';
      final medical = prefs.getString('expense_medical') ?? '';
      final education = prefs.getString('expense_education') ?? '';
      final electricityBill = prefs.getString('expense_electricity_bill') ?? '';
      final fuelCost = prefs.getString('expense_fuel_cost') ?? '';
      final transportationCost = prefs.getString('expense_transportation_cost') ?? '';
      final mobileInternetBill = prefs.getString('expense_mobile_internet_bill') ?? '';
      final houseRepair = prefs.getString('expense_house_repair') ?? '';
      final landTax = prefs.getString('expense_land_tax') ?? '';
      final festival = prefs.getString('expense_festival') ?? '';
      final dishBill = prefs.getString('expense_dish_bill') ?? '';
      final generatorBill = prefs.getString('expense_generator_bill') ?? '';
      final domesticWorkerSalary = prefs.getString('expense_domestic_worker_salary') ?? '';
      final serviceCharge = prefs.getString('expense_service_charge') ?? '';
      final garbageBill = prefs.getString('expense_garbage_bill') ?? '';
      final others = prefs.getString('expense_others') ?? '';

      // Calculate total
      double total = 0.0;
      total += double.tryParse(food) ?? 0.0;
      total += double.tryParse(houseRent) ?? 0.0;
      total += double.tryParse(loanInstallment) ?? 0.0;
      total += double.tryParse(dps) ?? 0.0;
      total += double.tryParse(clothingPurchase) ?? 0.0;
      total += double.tryParse(medical) ?? 0.0;
      total += double.tryParse(education) ?? 0.0;
      total += double.tryParse(electricityBill) ?? 0.0;
      total += double.tryParse(fuelCost) ?? 0.0;
      total += double.tryParse(transportationCost) ?? 0.0;
      total += double.tryParse(mobileInternetBill) ?? 0.0;
      total += double.tryParse(houseRepair) ?? 0.0;
      total += double.tryParse(landTax) ?? 0.0;
      total += double.tryParse(festival) ?? 0.0;
      total += double.tryParse(dishBill) ?? 0.0;
      total += double.tryParse(generatorBill) ?? 0.0;
      total += double.tryParse(domesticWorkerSalary) ?? 0.0;
      total += double.tryParse(serviceCharge) ?? 0.0;
      total += double.tryParse(garbageBill) ?? 0.0;
      total += double.tryParse(others) ?? 0.0;

      if (mounted) {
        setState(() {
          _cashOutData = {
            'Food Expense': food,
            'House Rent': houseRent,
            'Loan Installment': loanInstallment,
            'DPS': dps,
            'Clothing Purchase': clothingPurchase,
            'Medical': medical,
            'Education': education,
            'Electricity Bill': electricityBill,
            'Fuel Cost': fuelCost,
            'Transportation Cost': transportationCost,
            'Mobile & Internet Bill': mobileInternetBill,
            'House Repair': houseRepair,
            'Land Tax': landTax,
            'Festival Expense': festival,
            'Dish Bill': dishBill,
            'Generator Bill': generatorBill,
            'Domestic Worker Salary': domesticWorkerSalary,
            'Service Charge': serviceCharge,
            'Garbage Bill': garbageBill,
            'Others': others,
          };
          _total = total;
        });
      }
    } catch (e) {
      debugPrint('Error loading cash out data: $e');
    }
  }

  String _formatNumber(String value) {
    if (value.isEmpty || value == '0') return '0';
    final numValue = double.tryParse(value) ?? 0.0;
    if (numValue == 0.0) return '0';
    return numValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Out Flow Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Amount (৳)',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Table Body
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                  },
                  children: _cashOutData.entries.map((entry) {
                    final value = entry.value.isEmpty || entry.value == '0'
                        ? '0'
                        : _formatNumber(entry.value);
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              
              // Total Row
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                    right: BorderSide(color: Colors.grey[300]!),
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _formatNumber(_total.toString()),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ],
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

