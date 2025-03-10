import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../utils/constants.dart';
import '../widgets/semester_card.dart';
import 'course_list_page.dart';
import 'school_selection_page.dart';

class SemesterSelectionPage extends StatelessWidget {
  final int academicYear;

  const SemesterSelectionPage({super.key, required this.academicYear});

  @override
  Widget build(BuildContext context) {
    // Filter semesters by academic year
    final semesters = AppConstants.semesters
        .where((semester) => semester.academicYear == academicYear)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Year $academicYear - Semester'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Semester',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your current semester to find relevant courses',
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
                  itemCount: semesters.length,
                  itemBuilder: (context, index) {
                    final semester = semesters[index];
                    return SemesterCard(
                      semester: semester,
                      onTap: () => _selectSemester(context, semester),
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

  void _selectSemester(BuildContext context, Semester semester) {
    if (academicYear == 1) {
      // For year 1, go directly to course list
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseListPage(
            academicYear: academicYear, 
            semesterId: semester.id,
            skipDepartmentSelection: true,
          ),
        ),
      );
    } else {
      // For year 2+, go to school selection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SchoolSelectionPage(
            academicYear: academicYear,
            semesterId: semester.id,
          ),
        ),
      );
    }
  }
}