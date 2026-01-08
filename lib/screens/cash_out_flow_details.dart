import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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
                'Cash Out Flow Details',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
              pw.SizedBox(height: 20),
              
              // Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.red50),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Category',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Amount (৳)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Data Rows
                  ..._cashOutData.entries.map((entry) {
                    final value = entry.value.isEmpty || entry.value == '0'
                        ? '0'
                        : _formatNumber(entry.value);
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            entry.key,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            value,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  
                  // Total Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.red50),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: PdfColors.red900,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          _formatNumber(_total.toString()),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: PdfColors.red900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal[50],
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
                              color: Colors.teal[900],
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
                              color: Colors.teal[900],
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
                  color: Colors.teal[50],
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
                              color: Colors.teal[900],
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
                              color: Colors.teal[900],
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