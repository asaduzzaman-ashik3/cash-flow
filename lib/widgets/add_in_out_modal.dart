import 'package:flutter/material.dart';
import 'package:cash_flow/screens/add_cash_in.dart';
import 'package:cash_flow/screens/add_cash_out.dart';

class AddInOutModal extends StatelessWidget {
  final Function() onCashInAdded;
  final Function() onCashOutAdded;

  const AddInOutModal({
    Key? key,
    required this.onCashInAdded,
    required this.onCashOutAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Add New Entry',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCashIn()),
                      ).then((_) => onCashInAdded());
                    },
                    icon: Icon(Icons.trending_up, color: Colors.white),
                    label: Text('Add Cash In', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCashOut()),
                      ).then((_) => onCashOutAdded());
                    },
                    icon: Icon(Icons.trending_down, color: Colors.white),
                    label: Text('Add Cash Out', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}