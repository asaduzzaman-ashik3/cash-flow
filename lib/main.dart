import 'package:flutter/material.dart';

import 'widgets/stat_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Cash Flow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),child: Column(
          children: [
            StatCard(
              title: "Total Earn",
              value: "\$5,200",
              color: Colors.green,
              icon: Icons.attach_money,
            ),
            SizedBox(width: 12),
            StatCard(
              title: "Total Expense",
              value: "\$2,300",
              color: Colors.red,
              icon: Icons.money_off,
            ),
            SizedBox(width: 12),
            StatCard(
              title: "Net Earning",
              value: "\$2,900",
              color: Colors.orange,
              icon: Icons.trending_up,
            )

          ],
        ),),
      )
    );
  }
}
