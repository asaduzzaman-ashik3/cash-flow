import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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

  pw.Widget _buildTwoColumnRow({
    required String category,
    required String amount,
    bool isHeader = false,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              child: pw.Text(
                category,
                style: pw.TextStyle(
                  fontSize: isHeader ? 10 : 9,
                  fontWeight: isHeader 
                      ? pw.FontWeight.bold 
                      : pw.FontWeight.normal,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                amount,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: isHeader ? 10 : 9,
                  fontWeight: isHeader 
                      ? pw.FontWeight.bold 
                      : pw.FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Net Earning Details',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
              pw.SizedBox(height: 20),
              
              // Two Column Layout
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left Column - Cash In Flow
                  pw.Expanded(
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Header
                          pw.Container(
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.blue50,
                            ),
                            child: pw.Text(
                              'CASH IN FLOW (EARN)',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          // Header Row
                          _buildTwoColumnRow(
                            category: 'Category',
                            amount: 'Amount (৳)',
                            isHeader: true,
                          ),
                          // Cash In Data Rows
                          ..._cashInData.entries.map((entry) {
                            final value = entry.value.isEmpty || entry.value == '0'
                                ? '0'
                                : _formatNumber(entry.value);
                            return _buildTwoColumnRow(
                              category: entry.key,
                              amount: value,
                            );
                          }).toList(),
                          // Cash In Total
                          pw.Container(
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.green50,
                              border: pw.Border(
                                top: pw.BorderSide(color: PdfColors.grey300, width: 1),
                              ),
                            ),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Total Cash In',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green900,
                                  ),
                                ),
                                pw.Text(
                                  _formatNumber(_totalCashIn.toString()),
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  pw.SizedBox(width: 10),
                  
                  // Right Column - Cash Out Flow
                  pw.Expanded(
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Header
                          pw.Container(
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.red50,
                            ),
                            child: pw.Text(
                              'CASH OUT FLOW (EXPENSE)',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red900,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          // Header Row
                          _buildTwoColumnRow(
                            category: 'Category',
                            amount: 'Amount (৳)',
                            isHeader: true,
                          ),
                          // Cash Out Data Rows
                          ..._cashOutData.entries.map((entry) {
                            final value = entry.value.isEmpty || entry.value == '0'
                                ? '0'
                                : _formatNumber(entry.value);
                            return _buildTwoColumnRow(
                              category: entry.key,
                              amount: value,
                            );
                          }).toList(),
                          // Cash Out Total
                          pw.Container(
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(8),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.red50,
                              border: pw.Border(
                                top: pw.BorderSide(color: PdfColors.grey300, width: 1),
                              ),
                            ),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Total Cash Out',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.red900,
                                  ),
                                ),
                                pw.Text(
                                  _formatNumber(_totalCashOut.toString()),
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.red900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Net Earning Summary
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.orange50,
                  border: pw.Border.all(color: PdfColors.orange300, width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'NET EARNING',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange900,
                      ),
                    ),
                    pw.Text(
                      _formatNumber(_netEarning.toString()),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _viewPdf() async {
    final pdfBytes = await _generatePdf();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
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
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PDF Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _viewPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Cash In Table
              _buildTable(
                title: 'Cash In Flow',
                data: _cashInData,
                total: _totalCashIn,
                headerColor: Colors.blue,
                totalColor: Colors.green,
              ),
              
              const SizedBox(height: 16),
              
              // Cash Out Table
              _buildTable(
                title: 'Cash Out Flow',
                data: _cashOutData,
                total: _totalCashOut,
                headerColor: Colors.red,
                totalColor: Colors.red,
              ),
              
              const SizedBox(height: 12),
              
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

