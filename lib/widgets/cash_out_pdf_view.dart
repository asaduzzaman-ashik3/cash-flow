import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CashOutPdfView {
  static Future<void> generateAndPrintPdf(Map<String, String> cashOutData, double total) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Cash Out Flow Details',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 20),

              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header Row
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '#',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Category Name',
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
                  ...cashOutData.entries.map((entry) {
                    final value = _formatNumberForPdf(entry.value);
                    int index = cashOutData.keys.toList().indexOf(entry.key) + 1;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            index.toString(),
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
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
                  }),
                  // Total Row
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
          ),
          ];
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
  
  static Future<Map<String, String>> loadCashOutData() async {
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

      // Load dynamic fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_out_fields') ?? [];
      Map<String, String> dynamicFields = {};
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          dynamicFields[label] = prefs.getString('dynamic_cash_out_field_$label') ?? '';
        }
      }

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
      
      // Add dynamic fields to total
      for (final value in dynamicFields.values) {
        total += double.tryParse(value) ?? 0.0;
      }

      return {
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
        ...dynamicFields, // Add all dynamic fields
      };
    } catch (e) {
      debugPrint('Error loading cash out data: $e');
      return {};
    }
  }
  
  static Future<double> calculateTotalCashOut() async {
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

      // Load dynamic fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_out_fields') ?? [];
      Map<String, String> dynamicFields = {};
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          dynamicFields[label] = prefs.getString('dynamic_cash_out_field_$label') ?? '';
        }
      }

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
      
      // Add dynamic fields to total
      for (final value in dynamicFields.values) {
        total += double.tryParse(value) ?? 0.0;
      }

      return total;
    } catch (e) {
      debugPrint('Error calculating total cash out: $e');
      return 0.0;
    }
  }
}