import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/document.dart';
import '../services/api_service.dart';
import '../services/gemini_service.dart';
import '../utils/theme.dart';

class DocumentViewerPage extends StatefulWidget {
  final Document document;

  const DocumentViewerPage({
    super.key,
    required this.document,
  });

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  final ApiService _apiService = ApiService();
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _queryController = TextEditingController();
  
  bool _isLoading = true;
  bool _isDownloading = false;
  bool _isSearching = false;
  bool _isTextSearch = true;
  bool _hasSubmitted = false;
  String _localPath = '';
  String _errorMessage = '';
  String _response = '';
  File? _selectedImage;
  
  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // In a real app, check if document is already cached first
      final url = widget.document.fileUrl;
      setState(() {
        _isLoading = false;
        // For demo purposes, we're just displaying the URL
        // In a real app, this would be a local file path or handled by a viewer
        _localPath = url;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load document: $e';
      });
    }
  }

  Future<void> _downloadDocument() async {
    setState(() {
      _isDownloading = true;
      _errorMessage = '';
    });
    
    try {
      final path = await _apiService.downloadDocument(widget.document.fileUrl);
      setState(() {
        _isDownloading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document downloaded successfully')),
        );
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Failed to download document: $e';
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    
    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }
  
  Future<void> _submitQuery() async {
    final query = _queryController.text.trim();
    
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }
    
    setState(() {
      _isSearching = true;
      _hasSubmitted = true;
      _response = '';
    });
    
    try {
      if (_isTextSearch) {
        final response = await _geminiService.getTextExplanation(query);
        setState(() {
          _response = response;
        });
      } else {
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image')),
          );
          setState(() {
            _isSearching = false;
          });
          return;
        }
        
        final response = await _geminiService.getImageExplanation(query, _selectedImage!);
        setState(() {
          _response = response;
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => _buildAISearchSheet(context),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _isDownloading ? null : _downloadDocument,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? _buildErrorState()
                : _buildDocumentViewer(),
      ),
    );
  }

  Widget _buildAISearchSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-Powered Search',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask a question about this document or upload an image for AI to analyze',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                
                // Search type toggle
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(
                            value: true,
                            label: Text('Text Search'),
                            icon: Icon(Icons.text_fields),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: Text('Image Search'),
                            icon: Icon(Icons.image),
                          ),
                        ],
                        selected: {_isTextSearch},
                        onSelectionChanged: (Set<bool> selection) {
                          setState(() {
                            _isTextSearch = selection.first;
                            _selectedImage = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Query input
                TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Enter your question here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _queryController.clear();
                      },
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
                const SizedBox(height: 16),
                
                // Image picker (for image search)
                if (!_isTextSearch) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload Image'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (_selectedImage != null) ...[
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
                
                // Submit button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSearching ? null : _submitQuery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSearching
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Get AI Explanation'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Response display
                if (_hasSubmitted) ...[
                  Text(
                    'AI Response:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _isSearching
                        ? const Center(child: CircularProgressIndicator())
                        : SelectableText(_response),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loadDocument,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentViewer() {
    // For demo purposes, we're just showing a placeholder
    // In a real app, you would use flutter_pdfview or a similar package
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.file_present,
                    size: 120,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.document.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (widget.document.description != null) ...[
                    Text(
                      widget.document.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Document URL: $_localPath',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'In a real app, the document would be displayed here using an appropriate viewer.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isDownloading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LinearProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isDownloading ? null : _downloadDocument,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_isDownloading ? 'Downloading...' : 'Download Document'),
            ),
          ),
        ),
      ],
    );
  }
}