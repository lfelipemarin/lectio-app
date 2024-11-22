import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectio_app/models/lectio_model.dart';

class LectioState {
  final List<LectioModel> lectios;
  final bool isLoading;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final String? createdAtFilter;

  LectioState({
    this.lectios = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.lastDocument,
    this.createdAtFilter,
  });

  LectioState copyWith({
    List<LectioModel>? lectios,
    bool? isLoading,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    String? createdAtFilter,
  }) {
    return LectioState(
      lectios: lectios ?? this.lectios,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
    );
  }
}
