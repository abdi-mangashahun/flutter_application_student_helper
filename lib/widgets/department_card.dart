import 'package:flutter/material.dart';
import '../models/department.dart';

class DepartmentCard extends StatelessWidget {
  final Department department;
  final VoidCallback onTap;

  const DepartmentCard({
    super.key,
    required this.department,
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
                _getIconForDepartment(department.id),
                size: 48,
                color: _getColorForDepartment(department.id),
              ),
              const SizedBox(height: 12),
              Text(
                department.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForDepartment(String id) {
    switch (id) {
      case 'cs':
        return Icons.computer;
      case 'eng':
        return Icons.engineering;
      case 'med':
        return Icons.medical_services;
      case 'bus':
        return Icons.business;
      default:
        return Icons.school;
    }
  }

  Color _getColorForDepartment(String id) {
    switch (id) {
      case 'cs':
        return Colors.blue;
      case 'eng':
        return Colors.orange;
      case 'med':
        return Colors.red;
      case 'bus':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}