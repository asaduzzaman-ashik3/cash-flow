import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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
                'Cash In Flow Details',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
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
                    decoration: const pw.BoxDecoration(color: PdfColors.blue50),
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
                          'Amount',
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
                  ..._cashInData.entries.map((entry) {
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
                            style:  pw.TextStyle(
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
                    decoration: const pw.BoxDecoration(color: PdfColors.green50),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: PdfColors.green900,
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
                            color: PdfColors.green900,
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

