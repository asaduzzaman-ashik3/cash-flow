import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CashInPdfView {
  static Future<void> generateAndPrintPdf(Map<String, String> cashInData, double total) async {
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
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
              ),
              pw.SizedBox(height: 20),
              
              // Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(

                    ),
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
                  ...cashInData.entries.map((entry) {
                    final value = _formatNumberForPdf(entry.value);
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
                    decoration: const pw.BoxDecoration(),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          _formatNumberForPdf(total.toString()),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
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

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static String _formatNumberForPdf(String value) {
    if (value.isEmpty || value == '0') return '0';
    final numValue = double.tryParse(value) ?? 0.0;
    if (numValue == 0.0) return '0';
    return numValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  static Future<Map<String, String>> loadCashInData() async {
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

      // Load dynamic fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_in_fields') ?? [];
      Map<String, String> dynamicFields = {};
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          dynamicFields[label] = prefs.getString('dynamic_cash_in_field_$label') ?? '';
        }
      }

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
      
      // Add dynamic fields to total
      for (final value in dynamicFields.values) {
        total += double.tryParse(value) ?? 0.0;
      }

      return {
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
        ...dynamicFields, // Add all dynamic fields
      };
    } catch (e) {
      debugPrint('Error loading cash in data: $e');
      return {};
    }
  }
  
  static Future<double> calculateTotalCashIn() async {
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

      // Load dynamic fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_in_fields') ?? [];
      Map<String, String> dynamicFields = {};
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          dynamicFields[label] = prefs.getString('dynamic_cash_in_field_$label') ?? '';
        }
      }

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
      
      // Add dynamic fields to total
      for (final value in dynamicFields.values) {
        total += double.tryParse(value) ?? 0.0;
      }

      return total;
    } catch (e) {
      debugPrint('Error calculating total cash in: $e');
      return 0.0;
    }
  }
}