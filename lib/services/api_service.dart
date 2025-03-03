import '../models/course.dart';
import '../models/department.dart';
import '../models/document.dart';
import '../models/semester.dart';
import '../utils/constants.dart';

// This is a mock service for demonstration.
// In a real app, you would connect to a backend API.
class ApiService {
  // Get departments
  Future<List<Department>> getDepartments() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return AppConstants.departments;
  }
  
  // Get courses by department and academic year
  Future<List<Course>> getCourses(String departmentId, int academicYear) async {
    await Future.delayed(const Duration(milliseconds: 700)); // Simulate network delay
    return AppConstants.courses.where((course) => 
      course.departmentId == departmentId && course.academicYear == academicYear
    ).toList();
  }
  
  // Get documents by course and type
  Future<List<Document>> getDocuments(String courseId, DocumentType type) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    return AppConstants.documents.where((doc) => 
      doc.courseId == courseId && doc.type == type
    ).toList();
  }
  
  // Get semesters by academic year
  Future<List<Semester>> getSemestersByYear(int academicYear) async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    return AppConstants.semesters.where((semester) => 
      semester.academicYear == academicYear
    ).toList();
  }
  
  // Download document
  Future<String> downloadDocument(String fileUrl) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate download time
    // In a real app, this would download the file and return the local path
    return fileUrl;
  }
}