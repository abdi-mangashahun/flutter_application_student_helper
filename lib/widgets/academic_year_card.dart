import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AcademicYearCard extends StatelessWidget {
  final int year;
  final VoidCallback onTap;

  const AcademicYearCard({
    super.key,
    required this.year,
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
                Icons.school,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Year $year',
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