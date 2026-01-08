import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashInFlowDetails extends StatefulWidget {
  const CashInFlowDetails({super.key});

  @override
  State<CashInFlowDetails> createState() => _CashInFlowDetailsState();
}

class _CashInFlowDetailsState extends State<CashInFlowDetails> {
  Map<String, String> _cashInData = {};
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCashInData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCashInData();
  }

  Future<void> _loadCashInData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
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

      // Calculate total
      double total = 0.0;
      total += double.tryParse(ownSalary) ?? 0.0;
      total += double.tryParse(spouseSalary) ?? 0.0;
      total += double.tryParse(childSalary) ?? 0.0;
      total += double.tryParse(parentSalary) ?? 0.0;
      total += double.tryParse(savingsProfit) ?? 0.0;
      total += double.tryParse(houseRent) ?? 0.0;
      total += double.tryParse(businessIncome) ?? 0.0;
      total += double.tryParse(agricultureIncome) ?? 0.0;
      total += double.tryParse(animalRearing) ?? 0.0;
      total += double.tryParse(treesPlantsSale) ?? 0.0;
      total += double.tryParse(fruitsSale) ?? 0.0;
      total += double.tryParse(others) ?? 0.0;

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
          _total = total;
        });
      }
    } catch (e) {
      debugPrint('Error loading cash in data: $e');
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
        title: const Text("Cash In Flow Details"),
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
                  color: Colors.blue[50],
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
                              color: Colors.blue[900],
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
                              color: Colors.blue[900],
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
                  children: _cashInData.entries.map((entry) {
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
                  color: Colors.green[50],
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
                              color: Colors.green[900],
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
                              color: Colors.green[900],
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

