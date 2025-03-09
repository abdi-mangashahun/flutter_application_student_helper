import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/academic_year_card.dart';
import 'semester_selection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Helper'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Academic Year',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your current year to find relevant courses',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: AppConstants.academicYears.length,
                  itemBuilder: (context, index) {
                    final year = AppConstants.academicYears[index];
                    return AcademicYearCard(
                      year: year,
                      onTap: () => _selectAcademicYear(context, year),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAcademicYear(BuildContext context, int year) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SemesterSelectionPage(academicYear: year),
      ),
    );
  }
}