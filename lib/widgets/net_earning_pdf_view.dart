import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class NetEarningPdfView {
  static Future<void> generateAndPrintPdf(
    Map<String, String> cashInData,
    Map<String, String> cashOutData,
    double totalCashIn,
    double totalCashOut,
    double netEarning,
  ) async {
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
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 20),
              
              // Table with Cash In and Cash Out
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
                          'CASH IN FLOW (EARN)',
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
                          'CASH OUT FLOW (EXPENSE)',
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
                  
                  // Data Rows with numbering
                  ..._buildCashInAndOutRowsWithNumbers(cashInData, cashOutData),
                  
                  // Totals Row
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
                          'Total Cash In',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          _formatNumberForPdf(totalCashIn.toString()),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
                          'Total Cash Out',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          _formatNumberForPdf(totalCashOut.toString()),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Net Earning Row
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
                          'Net Earning',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          _formatNumberForPdf(netEarning.toString()),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(''),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(''),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(''),
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

  // Helper function to build cash in and cash out rows with numbering
  static List<pw.TableRow> _buildCashInAndOutRowsWithNumbers(Map<String, String> cashInData, Map<String, String> cashOutData) {
    final maxRows = cashInData.length > cashOutData.length ? cashInData.length : cashOutData.length;
    final List<pw.TableRow> result = [];
    
    final cashInEntries = cashInData.entries.toList();
    final cashOutEntries = cashOutData.entries.toList();
    
    for (int i = 0; i < maxRows; i++) {
      String cashInNumber = i < cashInData.length ? "${i + 1}" : "";
      String cashInLabel = '';
      String cashInAmount = '';
      String cashOutNumber = i < cashOutData.length ? "${i + 1}" : "";
      String cashOutLabel = '';
      String cashOutAmount = '';
      
      if (i < cashInEntries.length) {
        cashInLabel = cashInEntries[i].key;
        cashInAmount = _formatNumberForPdf(cashInEntries[i].value);
      }
      
      if (i < cashOutEntries.length) {
        cashOutLabel = cashOutEntries[i].key;
        cashOutAmount = _formatNumberForPdf(cashOutEntries[i].value);
      }
      
      result.add(pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashInNumber,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashInLabel,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashInAmount,
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashOutNumber,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashOutLabel,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              cashOutAmount,
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ));
    }
    
    return result;
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
  
  static Future<Map<String, dynamic>> loadData() async {
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

      // Load dynamic fields
      final dynamicFieldsJson = prefs.getStringList('dynamic_fields') ?? [];
      Map<String, String> dynamicFields = {};
      for (String fieldJson in dynamicFieldsJson) {
        final parts = fieldJson.split('|');
        if (parts.length >= 2) {
          final label = parts[0];
          dynamicFields[label] = prefs.getString('dynamic_field_$label') ?? '';
        }
      }

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
      
      // Add dynamic fields to total
      for (final value in dynamicFields.values) {
        totalCashIn += double.tryParse(value) ?? 0.0;
      }

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

      return {
        'cashInData': {
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
          ...dynamicFields,
        },
        'cashOutData': {
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
        },
        'totalCashIn': totalCashIn,
        'totalCashOut': totalCashOut,
        'netEarning': netEarning,
      };
    } catch (e) {
      debugPrint('Error loading net earning data: $e');
      return {
        'cashInData': {},
        'cashOutData': {},
        'totalCashIn': 0.0,
        'totalCashOut': 0.0,
        'netEarning': 0.0,
      };
    }
  }
}