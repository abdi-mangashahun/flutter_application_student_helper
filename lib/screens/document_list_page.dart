import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/document.dart';
import '../services/api_service.dart';
import '../widgets/document_card.dart';
import 'document_viewer_page.dart';

class DocumentListPage extends StatefulWidget {
  final Course course;
  final DocumentType documentType;

  const DocumentListPage({
    super.key,
    required this.course,
    required this.documentType,
  });

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Document> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final documents = await _apiService.getDocuments(
        widget.course.id,
        widget.documentType,
      );
      setState(() {
        _documents = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load documents');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.documentType == DocumentType.exam
        ? 'Past Exams'
        : 'Course Materials';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _documents.isEmpty
                ? _buildEmptyState()
                : _buildDocumentList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.documentType == DocumentType.exam
                ? Icons.assignment_outlined
                : Icons.book_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No documents available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.documentType == DocumentType.exam
                ? 'There are no past exams for this course yet'
                : 'There are no materials for this course yet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _loadDocuments,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.documentType == DocumentType.exam
                ? 'Available Past Exams'
                : 'Available Course Materials',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on a document to view or download',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final document = _documents[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: DocumentCard(
                    document: document,
                    onTap: () => _openDocument(document),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDocument(Document document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerPage(document: document),
      ),
    );
  }
}