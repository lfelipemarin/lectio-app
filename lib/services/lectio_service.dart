
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectio_app/models/lectio_model.dart';

class LectioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveLectio({
    required String? userId,
    required String actio,
    required bool completedActio,
    required String createdAt,
    required String lectio,
    required String meditatio,
    required String oratio,
    required bool reminder,
    required String updatedAt,
  }) async {
    // Construir el ID del documento
    final String documentId = 'lectio-$createdAt';

    // Ruta: users/{userId}/lectios/{documentId}
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('lectios')
        .doc(documentId)
        .set({
      'actio': actio,
      'completedActio': completedActio,
      'createdAt': createdAt,
      'lectio': lectio,
      'meditatio': meditatio,
      'oratio': oratio,
      'reminder': reminder,
      'updatedAt': updatedAt,
    });
  }

  // Fetch lectios with pagination (using limit and startAfter for next page)
  Future<List<LectioModel>> fetchLectios({
    required String userId,
    String? createdAt,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    Query query = _firestore
        .collection('lectio')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt')
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    if (createdAt != null && createdAt.isNotEmpty) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: createdAt);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      return LectioModel.fromFirestore(doc);
    }).toList();
  }

}
