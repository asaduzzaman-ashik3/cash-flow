import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetEarningDetails extends StatefulWidget {
  const NetEarningDetails({super.key});

  @override
  State<NetEarningDetails> createState() => _NetEarningDetailsState();
}

class _NetEarningDetailsState extends State<NetEarningDetails> {
  Map<String, String> _cashInData = {};
  Map<String, String> _cashOutData = {};
  double _totalCashIn = 0.0;
  double _totalCashOut = 0.0;
  double _netEarning = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load Cash In Data
      final ownSalary = prefs.getString('own_salary') ?? '';
      final spouseSalary = prefs.getString('husband_wife_salary') ?? '';
      final childSalary = prefs.getString('son_daughter_salary') ?? '';
      final parentSalary = prefs.getString('father_mother_salary') ?? '';
      final savingsProfit = prefs.getString('savings_earn') ?? '';
      final houseRent = prefs.getString('home_rent_earn') ?? '';
      final businessIncome = prefs.getString('business_earn') ?? '';
      final agricultureIncome = prefs.getString('agriculture_earn') ?? '';
      final animalRearing = prefs.getString('animal_increasing_earn') ?? '';
      final treesPlantsSale = prefs.getString('tree_sells_earn') ?? '';
      final fruitsSale = prefs.getString('fruit_sell_earn') ?? '';
      final others = prefs.getString('others') ?? '';

      // Calculate Cash In Total
      double totalCashIn = 0.0;
      totalCashIn += double.tryParse(ownSalary) ?? 0.0;
      totalCashIn += double.tryParse(spouseSalary) ?? 0.0;
      totalCashIn += double.tryParse(childSalary) ?? 0.0;
      totalCashIn += double.tryParse(parentSalary) ?? 0.0;
      totalCashIn += double.tryParse(savingsProfit) ?? 0.0;
      totalCashIn += double.tryParse(houseRent) ?? 0.0;
      totalCashIn += double.tryParse(businessIncome) ?? 0.0;
      totalCashIn += double.tryParse(agricultureIncome) ?? 0.0;
      totalCashIn += double.tryParse(animalRearing) ?? 0.0;
      totalCashIn += double.tryParse(treesPlantsSale) ?? 0.0;
      totalCashIn += double.tryParse(fruitsSale) ?? 0.0;
      totalCashIn += double.tryParse(others) ?? 0.0;

      // Load Cash Out Data
      final food = prefs.getString('expense_food') ?? '';
      final houseRentExpense = prefs.getString('expense_house_rent') ?? '';
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
      final othersExpense = prefs.getString('expense_others') ?? '';

      // Calculate Cash Out Total
      double totalCashOut = 0.0;
      totalCashOut += double.tryParse(food) ?? 0.0;
      totalCashOut += double.tryParse(houseRentExpense) ?? 0.0;
      totalCashOut += double.tryParse(loanInstallment) ?? 0.0;
      totalCashOut += double.tryParse(dps) ?? 0.0;
      totalCashOut += double.tryParse(clothingPurchase) ?? 0.0;
      totalCashOut += double.tryParse(medical) ?? 0.0;
      totalCashOut += double.tryParse(education) ?? 0.0;
      totalCashOut += double.tryParse(electricityBill) ?? 0.0;
      totalCashOut += double.tryParse(fuelCost) ?? 0.0;
      totalCashOut += double.tryParse(transportationCost) ?? 0.0;
      totalCashOut += double.tryParse(mobileInternetBill) ?? 0.0;
      totalCashOut += double.tryParse(houseRepair) ?? 0.0;
      totalCashOut += double.tryParse(landTax) ?? 0.0;
      totalCashOut += double.tryParse(festival) ?? 0.0;
      totalCashOut += double.tryParse(dishBill) ?? 0.0;
      totalCashOut += double.tryParse(generatorBill) ?? 0.0;
      totalCashOut += double.tryParse(domesticWorkerSalary) ?? 0.0;
      totalCashOut += double.tryParse(serviceCharge) ?? 0.0;
      totalCashOut += double.tryParse(garbageBill) ?? 0.0;
      totalCashOut += double.tryParse(othersExpense) ?? 0.0;

      // Calculate Net Earning
      final netEarning = totalCashIn - totalCashOut;

      if (mounted) {
        setState(() {
          _cashInData = {
            'Own Salary': ownSalary,
            'Spouse Salary': spouseSalary,
            'Child Salary': childSalary,
            'Parent Salary': parentSalary,
            'Savings Profit': savingsProfit,
            'House Rent': houseRent,
            'Business Income': businessIncome,
            'Agriculture Income': agricultureIncome,
            'Animal Rearing': animalRearing,
            'Trees/Plants Sale': treesPlantsSale,
            'Fruits Sale': fruitsSale,
            'Others': others,
          };
          
          _cashOutData = {
            'Food Expense': food,
            'House Rent': houseRentExpense,
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
            'Others': othersExpense,
          };
          
          _totalCashIn = totalCashIn;
          _totalCashOut = totalCashOut;
          _netEarning = netEarning;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
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

  Widget _buildTable({
    required String title,
    required Map<String, String> data,
    required double total,
    required Color headerColor,
    required Color totalColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
        
        // Table Header
        Container(
          decoration: BoxDecoration(
            color: Colors.green.shade50,
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
            children: data.entries.map((entry) {
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
            color: Colors.white,
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _formatNumber(total.toString()),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Net Earning Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cash In Table
              _buildTable(
                title: 'Cash In Flow',
                data: _cashInData,
                total: _totalCashIn,
                headerColor: Colors.blue,
                totalColor: Colors.green,
              ),
              
              const SizedBox(height: 32),
              
              // Cash Out Table
              _buildTable(
                title: 'Cash Out Flow',
                data: _cashOutData,
                total: _totalCashOut,
                headerColor: Colors.red,
                totalColor: Colors.red,
              ),
              
              const SizedBox(height: 32),
              
              // Net Earning Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Earning Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Cash In:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '৳ ${_formatNumber(_totalCashIn.toString())}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Cash Out:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '৳ ${_formatNumber(_totalCashOut.toString())}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Net Earning:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                        Text(
                          '৳ ${_formatNumber(_netEarning.toString())}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
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

