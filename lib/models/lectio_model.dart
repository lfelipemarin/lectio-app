import 'package:cloud_firestore/cloud_firestore.dart';

class LectioModel {
  final String userId;
  final String lectio;
  final String meditatio;
  final String oratio;
  final String actio;
  final String createdAt;
  final String updatedAt;
  final bool completedActio;
  final bool reminder;

  // Add this field to store the document snapshot
  final DocumentSnapshot? documentSnapshot;

  LectioModel({
    required this.userId,
    required this.lectio,
    required this.meditatio,
    required this.oratio,
    required this.actio,
    required this.createdAt,
    required this.updatedAt,
    required this.completedActio,
    required this.reminder,
    this.documentSnapshot, // Optional field
  });

  factory LectioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LectioModel(
      userId: data['userId'] ?? '',
      lectio: data['lectio'] ?? '',
      meditatio: data['meditatio'] ?? '',
      oratio: data['oratio'] ?? '',
      actio: data['actio'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      completedActio: data['completedActio'] ?? false,
      reminder: data['reminder'] ?? false,
      documentSnapshot: doc, // Store the snapshot
    );
  }
}
