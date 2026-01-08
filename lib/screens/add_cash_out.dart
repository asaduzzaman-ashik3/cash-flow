import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


class AddCashOut extends StatefulWidget {
  const AddCashOut({super.key});

  @override
  State<AddCashOut> createState() => _AddCashOutState();
}

class _AddCashOutState extends State<AddCashOut> {
  final TextEditingController _foodExpenseController = TextEditingController();
  final TextEditingController _houseRentController = TextEditingController();
  final TextEditingController _loanInstallmentController = TextEditingController();
  final TextEditingController _dpsController = TextEditingController();
  final TextEditingController _clothingPurchaseController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _electricityBillController = TextEditingController();
  final TextEditingController _fuelCostController = TextEditingController();
  final TextEditingController _transportationCostController = TextEditingController();
  final TextEditingController _mobileInternetBillController = TextEditingController();
  final TextEditingController _houseRepairController = TextEditingController();
  final TextEditingController _landTaxController = TextEditingController();
  final TextEditingController _festivalExpenseController = TextEditingController();
  final TextEditingController _dishBillController = TextEditingController();
  final TextEditingController _generatorBillController = TextEditingController();
  final TextEditingController _domesticWorkerSalaryController = TextEditingController();
  final TextEditingController _serviceChargeController = TextEditingController();
  final TextEditingController _garbageBillController = TextEditingController();
  final TextEditingController _othersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _foodExpenseController.text = prefs.getString('expense_food') ?? '';
          _houseRentController.text = prefs.getString('expense_house_rent') ?? '';
          _loanInstallmentController.text = prefs.getString('expense_loan_installment') ?? '';
          _dpsController.text = prefs.getString('expense_dps') ?? '';
          _clothingPurchaseController.text = prefs.getString('expense_clothing_purchase') ?? '';
          _medicalController.text = prefs.getString('expense_medical') ?? '';
          _educationController.text = prefs.getString('expense_education') ?? '';
          _electricityBillController.text = prefs.getString('expense_electricity_bill') ?? '';
          _fuelCostController.text = prefs.getString('expense_fuel_cost') ?? '';
          _transportationCostController.text = prefs.getString('expense_transportation_cost') ?? '';
          _mobileInternetBillController.text = prefs.getString('expense_mobile_internet_bill') ?? '';
          _houseRepairController.text = prefs.getString('expense_house_repair') ?? '';
          _landTaxController.text = prefs.getString('expense_land_tax') ?? '';
          _festivalExpenseController.text = prefs.getString('expense_festival') ?? '';
          _dishBillController.text = prefs.getString('expense_dish_bill') ?? '';
          _generatorBillController.text = prefs.getString('expense_generator_bill') ?? '';
          _domesticWorkerSalaryController.text = prefs.getString('expense_domestic_worker_salary') ?? '';
          _serviceChargeController.text = prefs.getString('expense_service_charge') ?? '';
          _garbageBillController.text = prefs.getString('expense_garbage_bill') ?? '';
          _othersController.text = prefs.getString('expense_others') ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading from SharedPreferences: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading saved data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final saveResults = await Future.wait([
        prefs.setString('expense_food', _foodExpenseController.text.trim()),
        prefs.setString('expense_house_rent', _houseRentController.text.trim()),
        prefs.setString('expense_loan_installment', _loanInstallmentController.text.trim()),
        prefs.setString('expense_dps', _dpsController.text.trim()),
        prefs.setString('expense_clothing_purchase', _clothingPurchaseController.text.trim()),
        prefs.setString('expense_medical', _medicalController.text.trim()),
        prefs.setString('expense_education', _educationController.text.trim()),
        prefs.setString('expense_electricity_bill', _electricityBillController.text.trim()),
        prefs.setString('expense_fuel_cost', _fuelCostController.text.trim()),
        prefs.setString('expense_transportation_cost', _transportationCostController.text.trim()),
        prefs.setString('expense_mobile_internet_bill', _mobileInternetBillController.text.trim()),
        prefs.setString('expense_house_repair', _houseRepairController.text.trim()),
        prefs.setString('expense_land_tax', _landTaxController.text.trim()),
        prefs.setString('expense_festival', _festivalExpenseController.text.trim()),
        prefs.setString('expense_dish_bill', _dishBillController.text.trim()),
        prefs.setString('expense_generator_bill', _generatorBillController.text.trim()),
        prefs.setString('expense_domestic_worker_salary', _domesticWorkerSalaryController.text.trim()),
        prefs.setString('expense_service_charge', _serviceChargeController.text.trim()),
        prefs.setString('expense_garbage_bill', _garbageBillController.text.trim()),
        prefs.setString('expense_others', _othersController.text.trim()),
      ]);

      final allSaved = saveResults.every((result) => result == true);
      
      if (mounted) {
        if (allSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Some data may not have been saved. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      debugPrint('Error saving to SharedPreferences: $e');
    }
    Navigator.pop(context);
  }

  Future<void> _resetValues() async {
    _foodExpenseController.clear();
    _houseRentController.clear();
    _loanInstallmentController.clear();
    _dpsController.clear();
    _clothingPurchaseController.clear();
    _medicalController.clear();
    _educationController.clear();
    _electricityBillController.clear();
    _fuelCostController.clear();
    _transportationCostController.clear();
    _mobileInternetBillController.clear();
    _houseRepairController.clear();
    _landTaxController.clear();
    _festivalExpenseController.clear();
    _dishBillController.clear();
    _generatorBillController.clear();
    _domesticWorkerSalaryController.clear();
    _serviceChargeController.clear();
    _garbageBillController.clear();
    _othersController.clear();
  }

  @override
  void dispose() {
    _foodExpenseController.dispose();
    _houseRentController.dispose();
    _loanInstallmentController.dispose();
    _dpsController.dispose();
    _clothingPurchaseController.dispose();
    _medicalController.dispose();
    _educationController.dispose();
    _electricityBillController.dispose();
    _fuelCostController.dispose();
    _transportationCostController.dispose();
    _mobileInternetBillController.dispose();
    _houseRepairController.dispose();
    _landTaxController.dispose();
    _festivalExpenseController.dispose();
    _dishBillController.dispose();
    _generatorBillController.dispose();
    _domesticWorkerSalaryController.dispose();
    _serviceChargeController.dispose();
    _garbageBillController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: SizedBox(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters:  [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: label,
            hintText: "৳ Amount",
            hintStyle: const TextStyle(fontSize: 13),
            labelStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
        )

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Cash Out Flow"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Row 1: Food Expense, House Rent
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Food Expense', _foodExpenseController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('House Rent', _houseRentController),
                  ),
                ],
              ),
              // Row 2: Loan Installment, DPS
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Loan Installment', _loanInstallmentController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('DPS', _dpsController),
                  ),
                ],
              ),
              // Row 3: Clothing Purchase, Medical
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Clothing Purchase', _clothingPurchaseController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Medical', _medicalController),
                  ),
                ],
              ),
              // Row 4: Education, Electricity Bill
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Education', _educationController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Electricity Bill', _electricityBillController),
                  ),
                ],
              ),
              // Row 5: Fuel Cost, Transportation Cost
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Fuel Cost', _fuelCostController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Transportation Cost', _transportationCostController),
                  ),
                ],
              ),
              // Row 6: Mobile & Internet Bill, House Repair
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Mobile & Internet Bill', _mobileInternetBillController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('House Repair', _houseRepairController),
                  ),
                ],
              ),
              // Row 7: Land Tax, Festival Expense
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Land Tax', _landTaxController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Festival Expense', _festivalExpenseController),
                  ),
                ],
              ),
              // Row 8: Dish Bill, Generator Bill
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Dish Bill', _dishBillController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Generator Bill', _generatorBillController),
                  ),
                ],
              ),
              // Row 9: Domestic Worker Salary, Service Charge
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Domestic Worker Salary', _domesticWorkerSalaryController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Service Charge', _serviceChargeController),
                  ),
                ],
              ),
              // Row 10: Garbage Bill, Others
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Garbage Bill', _garbageBillController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Others', _othersController),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetValues,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveValues,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

