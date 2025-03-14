import '../models/department.dart';
import '../models/course.dart';
import '../models/document.dart';
import '../models/school.dart';
import '../models/semester.dart';

// Mock data for demonstration
class AppConstants {

  static final List<int> academicYears = [1, 2, 3, 4, 5];

  static final List<Semester> semesters = [
    Semester(id: 1, name: '1st Semester', academicYear: 1),
    Semester(id: 2, name: '2nd Semester', academicYear: 1),
    Semester(id: 3, name: '1st Semester', academicYear: 2),
    Semester(id: 4, name: '2nd Semester', academicYear: 2),
    Semester(id: 5, name: '1st Semester', academicYear: 3),
    Semester(id: 6, name: '2nd Semester', academicYear: 3),
    Semester(id: 7, name: '1st Semester', academicYear: 4),
    Semester(id: 8, name: '2nd Semester', academicYear: 4),
    Semester(id: 9, name: '1st Semester', academicYear: 5),
    Semester(id: 10, name: '2nd Semester', academicYear: 5),
  ];

  static final List<School> schools = [
    School(
      id: 'comp_sci',
      name: 'School of Computer Science',
      imageUrl: 'assets/images/comp_sci.png',
    ),
    School(
      id: 'engineering',
      name: 'School of Engineering',
      imageUrl: 'assets/images/engineering.png',
    ),
    School(
      id: 'business',
      name: 'School of Business',
      imageUrl: 'assets/images/business.png',
    ),
    School(
      id: 'medicine',
      name: 'School of Medicine',
      imageUrl: 'assets/images/medicine.png',
    ),
  ];

  static final List<Department> departments = [
    Department(
      id: 'cs',
      name: 'Computer Science',
      imageUrl: 'assets/images/cs.png',
    ),
    Department(
      id: 'eng',
      name: 'Engineering',
      imageUrl: 'assets/images/eng.png',
    ),
    Department(
      id: 'med',
      name: 'Medicine',
      imageUrl: 'assets/images/med.png',
    ),
    Department(
      id: 'bus',
      name: 'Business',
      imageUrl: 'assets/images/bus.png',
    ),
  ];

  static final List<Course> courses = [
    Course(
      id: 'cs101',
      name: 'Introduction to Programming',
      departmentId: 'cs',
      academicYear: 1,
      code: 'CS101',
      description: 'Basic programming concepts',
    ),
    Course(
      id: 'cs201',
      name: 'Data Structures',
      departmentId: 'cs',
      academicYear: 2,
      code: 'CS201',
      description: 'Study of data structures and algorithms',
    ),
    Course(
      id: 'eng101',
      name: 'Engineering Principles',
      departmentId: 'eng',
      academicYear: 1,
      code: 'ENG101',
      description: 'Introduction to engineering principles',
    ),
  ];

  static final List<Document> documents = [
    Document(
      id: 'doc1',
      title: 'Midterm Exam 2024',
      courseId: 'cs101',
      type: DocumentType.exam,
      fileUrl: 'https://example.com/cs101_midterm_2024.pdf',
      uploadDate: DateTime(2024, 3, 15),
      description: 'Midterm exam from Spring 2024',
    ),
    Document(
      id: 'doc2',
      title: 'Final Exam 2023',
      courseId: 'cs101',
      type: DocumentType.exam,
      fileUrl: 'https://example.com/cs101_final_2023.pdf',
      uploadDate: DateTime(2023, 12, 10),
      description: 'Final exam from Fall 2023',
    ),
    Document(
      id: 'doc3',
      title: 'Programming Basics',
      courseId: 'cs101',
      type: DocumentType.material,
      fileUrl: 'https://example.com/cs101_basics.pdf',
      uploadDate: DateTime(2024, 1, 5),
      description: 'Study material for programming basics',
    ),
  ];

  // API Keys
  static const String geminiApiKey = 'AIzaSyAjepn-s3bG741AkAQhDFmJUANrC-U69Ck'; // Replace with your actual API key
}