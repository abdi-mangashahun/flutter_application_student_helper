import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/theme.dart';
import 'document_list_page.dart';
import '../models/document.dart';

class DocumentTypePage extends StatelessWidget {
  final Course course;

  const DocumentTypePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What are you looking for?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose the type of documents you need',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _buildOptionCard(
                context,
                'Past Exams',
                'View previous exams, quizzes, and tests',
                Icons.assignment,
                Colors.red,
                () => _navigateToDocumentList(context, DocumentType.exam),
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                'Course Materials',
                'Access lecture notes, slides, and reading materials',
                Icons.book,
                Colors.blue,
                () => _navigateToDocumentList(context, DocumentType.material),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.subtitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDocumentList(BuildContext context, DocumentType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListPage(
          course: course,
          documentType: type,
        ),
      ),
    );
  }
}