
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para el usuario autenticado
final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
