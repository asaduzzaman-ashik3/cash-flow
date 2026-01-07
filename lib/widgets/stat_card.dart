import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color?.withValues(alpha: 0.1) ?? Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color ?? Colors.blue,
                size: 20,
              ),
            ),
          if (icon != null) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                (value.isNotEmpty && value != "0" && value != "0,") ? value : "Not Available",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
