import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';

class GeminiService {
  final GenerativeModel _model;
  
  GeminiService() : _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: AppConstants.geminiApiKey,
  );
  
  Future<String> getTextExplanation(String query) async {
    try {
      final content = Content.text(query);
      final response = await _model.generateContent([content]);
      return response.text ?? 'No response generated';
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  Future<String> getImageExplanation(String query, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final mime = _getMimeType(imageFile.path);
      
      // Create a vision model instance
      final generativeModel = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: AppConstants.geminiApiKey,
      );
      
      // Create content with text and image
      final content = Content.multi([
        TextPart(query),
        DataPart(mime, bytes),
      ]);
      
      final response = await generativeModel.generateContent([content]);
      return response.text ?? 'No response generated';
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
}