import 'package:flutter/material.dart';

class CalculateLoanAmount extends StatefulWidget {
  const CalculateLoanAmount({super.key});

  @override
  State<CalculateLoanAmount> createState() => _CalculateLoanAmountState();
}

class _CalculateLoanAmountState extends State<CalculateLoanAmount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculate Loan Amount")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [Text("asfsadf"), Text("asfsadf"), Text("asfsadf")],
          ),
        ),
      ),
    );
  }
}
