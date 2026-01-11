import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCashIn extends StatefulWidget {
  const AddCashIn({super.key});

  @override
  State<AddCashIn> createState() => _AddCashInState();
}

class _AddCashInState extends State<AddCashIn> {
  final TextEditingController _ownSalaryController = TextEditingController();
  final TextEditingController _husbandWifeSalaryController =
      TextEditingController();
  final TextEditingController _sonDaughterSalaryController =
      TextEditingController();
  final TextEditingController _fatherMotherSalaryController =
      TextEditingController();
  final TextEditingController _savingsEarnController = TextEditingController();
  final TextEditingController _homeRentEarnController = TextEditingController();
  final TextEditingController _businessEarnController = TextEditingController();
  final TextEditingController _agricultureEarnController =
      TextEditingController();
  final TextEditingController _animalIncreasingEarnController =
      TextEditingController();
  final TextEditingController _treeSellsEarnController =
      TextEditingController();
  final TextEditingController _fruitSellEarnController =
      TextEditingController();
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
          _ownSalaryController.text = prefs.getString('own_salary') ?? '';
          _husbandWifeSalaryController.text =
              prefs.getString('husband_wife_salary') ?? '';
          _sonDaughterSalaryController.text =
              prefs.getString('son_daughter_salary') ?? '';
          _fatherMotherSalaryController.text =
              prefs.getString('father_mother_salary') ?? '';
          _savingsEarnController.text = prefs.getString('savings_earn') ?? '';
          _homeRentEarnController.text =
              prefs.getString('home_rent_earn') ?? '';
          _businessEarnController.text = prefs.getString('business_earn') ?? '';
          _agricultureEarnController.text =
              prefs.getString('agriculture_earn') ?? '';
          _animalIncreasingEarnController.text =
              prefs.getString('animal_increasing_earn') ?? '';
          _treeSellsEarnController.text =
              prefs.getString('tree_sells_earn') ?? '';
          _fruitSellEarnController.text =
              prefs.getString('fruit_sell_earn') ?? '';
          _othersController.text = prefs.getString('others') ?? '';
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
        prefs.setString('own_salary', _ownSalaryController.text.trim()),
        prefs.setString(
          'husband_wife_salary',
          _husbandWifeSalaryController.text.trim(),
        ),
        prefs.setString(
          'son_daughter_salary',
          _sonDaughterSalaryController.text.trim(),
        ),
        prefs.setString(
          'father_mother_salary',
          _fatherMotherSalaryController.text.trim(),
        ),
        prefs.setString('savings_earn', _savingsEarnController.text.trim()),
        prefs.setString('home_rent_earn', _homeRentEarnController.text.trim()),
        prefs.setString('business_earn', _businessEarnController.text.trim()),
        prefs.setString(
          'agriculture_earn',
          _agricultureEarnController.text.trim(),
        ),
        prefs.setString(
          'animal_increasing_earn',
          _animalIncreasingEarnController.text.trim(),
        ),
        prefs.setString(
          'tree_sells_earn',
          _treeSellsEarnController.text.trim(),
        ),
        prefs.setString(
          'fruit_sell_earn',
          _fruitSellEarnController.text.trim(),
        ),
        prefs.setString('others', _othersController.text.trim()),
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
              content: Text(
                'Some data may not have been saved. Please try again.',
              ),
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
    _ownSalaryController.clear();
    _husbandWifeSalaryController.clear();
    _sonDaughterSalaryController.clear();
    _fatherMotherSalaryController.clear();
    _savingsEarnController.clear();
    _homeRentEarnController.clear();
    _businessEarnController.clear();
    _agricultureEarnController.clear();
    _animalIncreasingEarnController.clear();
    _treeSellsEarnController.clear();
    _fruitSellEarnController.clear();
    _othersController.clear();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _ownSalaryController.dispose();
    _husbandWifeSalaryController.dispose();
    _sonDaughterSalaryController.dispose();
    _fatherMotherSalaryController.dispose();
    _savingsEarnController.dispose();
    _homeRentEarnController.dispose();
    _businessEarnController.dispose();
    _agricultureEarnController.dispose();
    _animalIncreasingEarnController.dispose();
    _treeSellsEarnController.dispose();
    _fruitSellEarnController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  // Helper method to create a text field
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: "৳ Amount",
            hintStyle: TextStyle(fontSize: 12),
            labelStyle: TextStyle(fontSize: 13),
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
      appBar: AppBar(title: const Text("Add Cash In Flow")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField('Own Salary', _ownSalaryController),
              const SizedBox(width: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField('Spouse Salary', _husbandWifeSalaryController),),
                  Expanded(child: _buildTextField('Child Salary', _sonDaughterSalaryController),)
                ],
              ),
              const SizedBox(width: 8),
              _buildTextField('Parent Salary', _fatherMotherSalaryController),
              _buildTextField('Savings Profit', _savingsEarnController),
              const SizedBox(width: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField('House Rent Income', _homeRentEarnController),),
                  Expanded(child: _buildTextField('Business Income', _businessEarnController),)
                ],
              ),
              const SizedBox(width: 8),
              _buildTextField('Agriculture Income', _agricultureEarnController),
              _buildTextField(
                'Animal Rearing',
                _animalIncreasingEarnController,
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField('Trees/Plants Sale', _treeSellsEarnController),),
                  Expanded(child: _buildTextField('Fruits Sale', _fruitSellEarnController),)
                ],
              ),
              const SizedBox(width: 8),
              _buildTextField('Others', _othersController),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
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
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Save', style: TextStyle(fontSize: 14)),
                      ),
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
