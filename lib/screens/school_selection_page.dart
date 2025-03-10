import 'package:flutter/material.dart';
import '../models/school.dart';
import '../utils/constants.dart';
import '../widgets/school_card.dart';
import 'course_list_page.dart';

class SchoolSelectionPage extends StatelessWidget {
  final int academicYear;
  final int semesterId;

  const SchoolSelectionPage({
    super.key, 
    required this.academicYear,
    required this.semesterId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Year $academicYear - School'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your School',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your school to find relevant departments',
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
                  itemCount: AppConstants.schools.length,
                  itemBuilder: (context, index) {
                    final school = AppConstants.schools[index];
                    return SchoolCard(
                      school: school,
                      onTap: () => _selectSchool(context, school),
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

  void _selectSchool(BuildContext context, School school) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseListPage(
          academicYear: academicYear,
          semesterId: semesterId,
          schoolId: school.id,
        ),
      ),
    );
  }
}