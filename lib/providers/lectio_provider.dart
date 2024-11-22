
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

    state = state.copyWith(isLoading: true);

    try {
      final query = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection("lectios")
          .orderBy('createdAt', descending: true)
          .limit(10);

      final snapshot = await query.get();

      final List<LectioModel> lectios = snapshot.docs
          .map((doc) => LectioModel.fromFirestore(doc))
          .toList();

      // Guarda los lectios originales en allLectios y actualiza lectios
      state = state.copyWith(
        allLectios: lectios,
        lectios: lectios,
        isLoading: false,
        hasMore: lectios.length == 10,
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
      // Restaurar todos los lectios si no hay filtro
      state = state.copyWith(lectios: state.allLectios, hasMore: state.allLectios.length == 10);
    } else {
      // Aplicar filtro
      final filteredLectios = state.allLectios.where((lectio) {
        return lectio.createdAt.contains(state.createdAtFilter!);
      }).toList();

      state = state.copyWith(lectios: filteredLectios, hasMore: filteredLectios.length == 10);
    }
  }


  Future<void> loadMoreLectios(User? user) async {
    if (user == null || !state.hasMore || state.isLoading) return;

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Construir la consulta inicial
      var query = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection("lectios")
          .orderBy('createdAt', descending: true)
          .startAfterDocument(state.lastDocument!)
          .limit(10);

      // Agregar filtro condicionalmente
      if (state.createdAtFilter != null && state.createdAtFilter!.isNotEmpty) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: state.createdAtFilter);
      }

      // Ejecutar la consulta
      final snapshot = await query.get();

      final List<LectioModel> lectios = snapshot.docs
          .map((doc) => LectioModel.fromFirestore(doc))
          .toList();

      // Actualizar el estado con los nuevos datos
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

