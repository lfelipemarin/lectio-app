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

  // Field to store the document snapshot
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
    this.documentSnapshot,
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

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'lectio': lectio,
      'meditatio': meditatio,
      'oratio': oratio,
      'actio': actio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedActio': completedActio,
      'reminder': reminder,
    };
  }

  LectioModel copyWith({
    String? userId,
    String? lectio,
    String? meditatio,
    String? oratio,
    String? actio,
    String? createdAt,
    String? updatedAt,
    bool? completedActio,
    bool? reminder,
    DocumentSnapshot? documentSnapshot,
  }) {
    return LectioModel(
      userId: userId ?? this.userId,
      lectio: lectio ?? this.lectio,
      meditatio: meditatio ?? this.meditatio,
      oratio: oratio ?? this.oratio,
      actio: actio ?? this.actio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedActio: completedActio ?? this.completedActio,
      reminder: reminder ?? this.reminder,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }
}
