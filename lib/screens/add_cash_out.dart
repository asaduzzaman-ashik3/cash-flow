import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCashOut extends StatefulWidget {
  const AddCashOut({super.key});

  @override
  State<AddCashOut> createState() => _AddCashOutState();
}

class _AddCashOutState extends State<AddCashOut> {
  final TextEditingController _foodGroceriesController = TextEditingController();
  final TextEditingController _utilitiesController = TextEditingController();
  final TextEditingController _rentMortgageController = TextEditingController();
  final TextEditingController _transportationController = TextEditingController();
  final TextEditingController _healthcareController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _clothingController = TextEditingController();
  final TextEditingController _entertainmentController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _loanPaymentsController = TextEditingController();
  final TextEditingController _homeMaintenanceController = TextEditingController();
  final TextEditingController _personalCareController = TextEditingController();
  final TextEditingController _communicationController = TextEditingController();
  final TextEditingController _shoppingController = TextEditingController();
  final TextEditingController _travelController = TextEditingController();
  final TextEditingController _giftsDonationsController = TextEditingController();
  final TextEditingController _taxesController = TextEditingController();
  final TextEditingController _childcareController = TextEditingController();
  final TextEditingController _petCareController = TextEditingController();
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
          _foodGroceriesController.text = prefs.getString('expense_food_groceries') ?? '';
          _utilitiesController.text = prefs.getString('expense_utilities') ?? '';
          _rentMortgageController.text = prefs.getString('expense_rent_mortgage') ?? '';
          _transportationController.text = prefs.getString('expense_transportation') ?? '';
          _healthcareController.text = prefs.getString('expense_healthcare') ?? '';
          _educationController.text = prefs.getString('expense_education') ?? '';
          _clothingController.text = prefs.getString('expense_clothing') ?? '';
          _entertainmentController.text = prefs.getString('expense_entertainment') ?? '';
          _insuranceController.text = prefs.getString('expense_insurance') ?? '';
          _loanPaymentsController.text = prefs.getString('expense_loan_payments') ?? '';
          _homeMaintenanceController.text = prefs.getString('expense_home_maintenance') ?? '';
          _personalCareController.text = prefs.getString('expense_personal_care') ?? '';
          _communicationController.text = prefs.getString('expense_communication') ?? '';
          _shoppingController.text = prefs.getString('expense_shopping') ?? '';
          _travelController.text = prefs.getString('expense_travel') ?? '';
          _giftsDonationsController.text = prefs.getString('expense_gifts_donations') ?? '';
          _taxesController.text = prefs.getString('expense_taxes') ?? '';
          _childcareController.text = prefs.getString('expense_childcare') ?? '';
          _petCareController.text = prefs.getString('expense_pet_care') ?? '';
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
        prefs.setString('expense_food_groceries', _foodGroceriesController.text.trim()),
        prefs.setString('expense_utilities', _utilitiesController.text.trim()),
        prefs.setString('expense_rent_mortgage', _rentMortgageController.text.trim()),
        prefs.setString('expense_transportation', _transportationController.text.trim()),
        prefs.setString('expense_healthcare', _healthcareController.text.trim()),
        prefs.setString('expense_education', _educationController.text.trim()),
        prefs.setString('expense_clothing', _clothingController.text.trim()),
        prefs.setString('expense_entertainment', _entertainmentController.text.trim()),
        prefs.setString('expense_insurance', _insuranceController.text.trim()),
        prefs.setString('expense_loan_payments', _loanPaymentsController.text.trim()),
        prefs.setString('expense_home_maintenance', _homeMaintenanceController.text.trim()),
        prefs.setString('expense_personal_care', _personalCareController.text.trim()),
        prefs.setString('expense_communication', _communicationController.text.trim()),
        prefs.setString('expense_shopping', _shoppingController.text.trim()),
        prefs.setString('expense_travel', _travelController.text.trim()),
        prefs.setString('expense_gifts_donations', _giftsDonationsController.text.trim()),
        prefs.setString('expense_taxes', _taxesController.text.trim()),
        prefs.setString('expense_childcare', _childcareController.text.trim()),
        prefs.setString('expense_pet_care', _petCareController.text.trim()),
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
    _foodGroceriesController.clear();
    _utilitiesController.clear();
    _rentMortgageController.clear();
    _transportationController.clear();
    _healthcareController.clear();
    _educationController.clear();
    _clothingController.clear();
    _entertainmentController.clear();
    _insuranceController.clear();
    _loanPaymentsController.clear();
    _homeMaintenanceController.clear();
    _personalCareController.clear();
    _communicationController.clear();
    _shoppingController.clear();
    _travelController.clear();
    _giftsDonationsController.clear();
    _taxesController.clear();
    _childcareController.clear();
    _petCareController.clear();
    _othersController.clear();
  }

  @override
  void dispose() {
    _foodGroceriesController.dispose();
    _utilitiesController.dispose();
    _rentMortgageController.dispose();
    _transportationController.dispose();
    _healthcareController.dispose();
    _educationController.dispose();
    _clothingController.dispose();
    _entertainmentController.dispose();
    _insuranceController.dispose();
    _loanPaymentsController.dispose();
    _homeMaintenanceController.dispose();
    _personalCareController.dispose();
    _communicationController.dispose();
    _shoppingController.dispose();
    _travelController.dispose();
    _giftsDonationsController.dispose();
    _taxesController.dispose();
    _childcareController.dispose();
    _petCareController.dispose();
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
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: "Amount",
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
        ),
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
              // Row 1: Food & Groceries, Utilities
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Food & Groceries', _foodGroceriesController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Utilities', _utilitiesController),
                  ),
                ],
              ),
              // Row 2: Rent/Mortgage, Transportation
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Rent/Mortgage', _rentMortgageController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Transportation', _transportationController),
                  ),
                ],
              ),
              // Row 3: Healthcare, Education
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Healthcare', _healthcareController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Education', _educationController),
                  ),
                ],
              ),
              // Row 4: Clothing, Entertainment
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Clothing', _clothingController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Entertainment', _entertainmentController),
                  ),
                ],
              ),
              // Row 5: Insurance, Loan Payments
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Insurance', _insuranceController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Loan Payments', _loanPaymentsController),
                  ),
                ],
              ),
              // Row 6: Home Maintenance, Personal Care
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Home Maintenance', _homeMaintenanceController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Personal Care', _personalCareController),
                  ),
                ],
              ),
              // Row 7: Communication, Shopping
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Communication', _communicationController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Shopping', _shoppingController),
                  ),
                ],
              ),
              // Row 8: Travel, Gifts/Donations
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Travel', _travelController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Gifts/Donations', _giftsDonationsController),
                  ),
                ],
              ),
              // Row 9: Taxes, Childcare
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Taxes', _taxesController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Childcare', _childcareController),
                  ),
                ],
              ),
              // Row 10: Pet Care, Others
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Pet Care', _petCareController),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField('Others', _othersController),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetValues,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveValues,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
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

