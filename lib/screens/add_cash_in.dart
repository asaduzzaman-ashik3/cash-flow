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

  // Dynamic fields
  List<TextEditingController> _dynamicValueControllers = [];
  List<String> _dynamicLabels = [];
  List<String> _dynamicFieldNames = [];
  
  // Controllers for modal inputs
  final TextEditingController _modalLabelController = TextEditingController();
  final TextEditingController _modalHintController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
    _loadDynamicFields();
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

  Future<void> _loadDynamicFields() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dynamicFieldsJson = prefs.getStringList('dynamic_cash_in_fields') ?? [];
      
      setState(() {
        // Clear existing dynamic fields
        _dynamicValueControllers.clear();
        _dynamicLabels.clear();
        _dynamicFieldNames.clear();

        // Load dynamic fields
        for (String fieldJson in dynamicFieldsJson) {
          final parts = fieldJson.split('|');
          if (parts.length >= 2) {
            final label = parts[0];
            final value = prefs.getString('dynamic_cash_in_field_$label') ?? '';
            
            _dynamicLabels.add(label);
            _dynamicFieldNames.add('dynamic_cash_in_field_$label');
            _dynamicValueControllers.add(TextEditingController(text: value));
          }
        }
      });
    } catch (e) {
      debugPrint('Error loading dynamic fields: $e');
    }
  }

  Future<void> _saveValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save static fields
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

      // Save dynamic fields
      List<String> dynamicFieldsJson = [];
      List<Future<bool>> dynamicSaveResults = [];
      
      for (int i = 0; i < _dynamicLabels.length; i++) {
        String label = _dynamicLabels[i];
        String value = _dynamicValueControllers[i].text.trim();
        
        dynamicFieldsJson.add('$label|${DateTime.now().millisecondsSinceEpoch}');
        dynamicSaveResults.add(prefs.setString('dynamic_cash_in_field_$label', value));
      }
      
      await prefs.setStringList('dynamic_cash_in_fields', dynamicFieldsJson);
      await Future.wait(dynamicSaveResults);

      final allSaved = saveResults.every((result) => result == true) && 
                       dynamicSaveResults.every((result) => result == true);

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
    
    // Clear dynamic fields
    for (var controller in _dynamicValueControllers) {
      controller.clear();
    }
  }

  // Show modal for adding a new dynamic field
  void _showAddFieldModal() {
    _modalLabelController.clear();
    _modalHintController.text = "৳ Amount"; // Set default hint text
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Dynamic Input'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _modalLabelController,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: 'Enter field label',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _modalHintController,
                decoration: const InputDecoration(
                  labelText: 'Hint Text',
                  hintText: '৳ Amount',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close modal
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addDynamicFieldFromModal();
                Navigator.of(context).pop(); // Close modal
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  
  // Add a new dynamic field from modal
  void _addDynamicFieldFromModal() {
    String label = _modalLabelController.text.trim();
    _modalHintController.text.trim();
    
    if (label.isNotEmpty) {
      setState(() {
        _dynamicLabels.add(label);
        _dynamicFieldNames.add('dynamic_cash_in_field_$label');
        _dynamicValueControllers.add(TextEditingController());
      });
    } else {
      // Show snackbar if label is empty
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a label'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
  //
  // // Remove a dynamic field
  // void _removeDynamicField(int index) {
  //   setState(() {
  //     _dynamicValueControllers.removeAt(index);
  //     _dynamicLabels.removeAt(index);
  //     _dynamicFieldNames.removeAt(index);
  //   });
  // }

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
    
    // Dispose dynamic controllers
    for (var controller in _dynamicValueControllers) {
      controller.dispose();
    }
    
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

  Widget _buildDynamicField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: TextField(
        controller: _dynamicValueControllers[index],
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: _dynamicLabels[index],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: "৳ Amount",
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Cash In Flow"),
        actions: [
          IconButton(
            onPressed: _showAddFieldModal,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
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
              
              // Dynamic fields section
              if (_dynamicLabels.isNotEmpty) ...[
                ...List.generate(_dynamicLabels.length, (index) => _buildDynamicField(index)),
              ],
              
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