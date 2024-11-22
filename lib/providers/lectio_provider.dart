import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectio_app/models/lectio_model.dart';

import '../views/lectios/lectios_state.dart';

final lectioProvider = StateNotifierProvider<LectioNotifier, LectioState>((ref) {
  return LectioNotifier(ref);
});

class LectioNotifier extends StateNotifier<LectioState> {
  LectioNotifier(this._ref) : super(LectioState());

  final Ref _ref;

  Future<void> loadLectios(User? user) async {
    if (user == null) return;

    if (state.isLoading) return; // Prevent loading if already loading

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      final query = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection("lectios")
          .orderBy('createdAt', descending: true)
          .limit(10);

      if (state.createdAtFilter != null && state.createdAtFilter!.isNotEmpty) {
        query.where('createdAt', isGreaterThanOrEqualTo: state.createdAtFilter);
      }

      final snapshot = await query.get();

      final List<LectioModel> lectios = snapshot.docs
          .map((doc) => LectioModel.fromFirestore(doc))
          .toList();

      // Update state with the new data and pagination information
      state = state.copyWith(
        lectios: lectios,
        isLoading: false,
        hasMore: lectios.length == 10,  // Check if there are more items to load
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Error loading lectios: $e');
    }
  }

  void setFilter(String? createdAtFilter) {
    state = state.copyWith(createdAtFilter: createdAtFilter);
    _applyFilter();
  }

  void _applyFilter() {
    if (state.createdAtFilter == null || state.createdAtFilter!.isEmpty) {
      // If no filter is set, return all the lectios
      state = state.copyWith(lectios: state.lectios);
    } else {
      // Filter based on the selected date (Assumes 'createdAt' is in 'yyyy-MM-dd' format)
      final filteredLectios = state.lectios.where((lectio) {
        return lectio.createdAt.contains(state.createdAtFilter!);
      }).toList();

      state = state.copyWith(lectios: filteredLectios);
    }
  }

  Future<void> loadMoreLectios(User? user) async {
    if (user == null || !state.hasMore || state.isLoading) return;

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      final query = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection("lectios")
          .startAfterDocument(state.lastDocument!)
          .limit(10);

      if (state.createdAtFilter != null && state.createdAtFilter!.isNotEmpty) {
        query.where('createdAt', isGreaterThanOrEqualTo: state.createdAtFilter);
      }

      final snapshot = await query.get();

      final List<LectioModel> lectios = snapshot.docs
          .map((doc) => LectioModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        lectios: [...state.lectios, ...lectios],
        isLoading: false,
        hasMore: lectios.length == 10,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Error loading more lectios: $e');
    }
  }
}

