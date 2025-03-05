import 'package:flutter/material.dart';
import '../models/department.dart';
import '../services/api_service.dart';
import '../widgets/department_card.dart';
import '../widgets/course_card.dart';
import 'document_type_page.dart';

class CourseListPage extends StatefulWidget {
  final int academicYear;
  final int semesterId;
  final String? schoolId;
  final bool skipDepartmentSelection;

  const CourseListPage({
    super.key, 
    required this.academicYear,
    required this.semesterId,
    this.schoolId,
    this.skipDepartmentSelection = false,
  });

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final ApiService _apiService = ApiService();
  Department? _selectedDepartment;
  bool _isLoading = true;
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // In a real app, you would filter departments by schoolId
      final departments = await _apiService.getDepartments();
      final filteredDepartments = widget.schoolId != null 
          ? departments.where((dept) => dept.id.startsWith(widget.schoolId!.substring(0, 2))).toList()
          : departments;
      
      setState(() {
        _departments = filteredDepartments;
        _isLoading = false;
        
        // If we should skip department selection (year 1) and we have departments, auto-select the first one
        if (widget.skipDepartmentSelection && filteredDepartments.isNotEmpty) {
          _selectedDepartment = filteredDepartments.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load departments');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String pageTitle = 'Year ${widget.academicYear}';
    if (widget.semesterId % 2 == 1) {
      pageTitle += ' - 1st Semester';
    } else {
      pageTitle += ' - 2nd Semester';
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _selectedDepartment == null
                ? _buildDepartmentSelection()
                : _buildCourseList(),
      ),
    );
  }

  Widget _buildDepartmentSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Department',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your department to see available courses',
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
              itemCount: _departments.length,
              itemBuilder: (context, index) {
                final department = _departments[index];
                return DepartmentCard(
                  department: department,
                  onTap: () => _selectDepartment(department),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return FutureBuilder(
      future: _apiService.getCourses(_selectedDepartment!.id, widget.academicYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load courses'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No courses found for this department and year'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _selectedDepartment = null;
                  }),
                  child: const Text('Change Department'),
                ),
              ],
            ),
          );
        }

        // In a real app, you would filter courses by semesterId
        final courses = snapshot.data!;
        final filteredCourses = courses.where((course) => 
          course.academicYear == widget.academicYear
        ).toList();
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!widget.skipDepartmentSelection)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() {
                        _selectedDepartment = null;
                      }),
                    ),
                  Expanded(
                    child: Text(
                      'Courses - ${_selectedDepartment!.name}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Select a course to view documents',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: filteredCourses.isEmpty
                    ? Center(
                        child: Text(
                          'No courses available for this semester',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CourseCard(
                              course: course,
                              onTap: () => _selectCourse(course),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectDepartment(Department department) {
    setState(() {
      _selectedDepartment = department;
    });
  }

  void _selectCourse(course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentTypePage(course: course),
      ),
    );
  }
}