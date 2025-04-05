import 'package:flutter/material.dart';
import '../models/school.dart';
import '../utils/theme.dart';

class SchoolCard extends StatelessWidget {
  final School school;
  final VoidCallback onTap;

  const SchoolCard({
    super.key,
    required this.school,
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
              // We'd normally load the image here, but using an icon for simplicity
              Icon(
                _getIconForSchool(school.id),
                size: 48,
                color: _getColorForSchool(school.id),
              ),
              const SizedBox(height: 12),
              Text(
                school.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForSchool(String id) {
    switch (id) {
      case 'comp_sci':
        return Icons.computer;
      case 'engineering':
        return Icons.engineering;
      case 'business':
        return Icons.business;
      case 'medicine':
        return Icons.medical_services;
      default:
        return Icons.school;
    }
  }

  Color _getColorForSchool(String id) {
    switch (id) {
      case 'comp_sci':
        return Colors.blue;
      case 'engineering':
        return Colors.orange;
      case 'business':
        return Colors.green;
      case 'medicine':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}