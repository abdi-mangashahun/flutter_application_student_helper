enum DocumentType { exam, material }

class Document {
  final String id;
  final String title;
  final String courseId;
  final DocumentType type;
  final String fileUrl;
  final DateTime uploadDate;
  final String? description;

  Document({
    required this.id,
    required this.title,
    required this.courseId,
    required this.type,
    required this.fileUrl,
    required this.uploadDate,
    this.description,
  });
}