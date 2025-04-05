import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../utils/theme.dart';

class SemesterCard extends StatelessWidget {
  final Semester semester;
  final VoidCallback onTap;

  const SemesterCard({
    super.key,
    required this.semester,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                semester.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}