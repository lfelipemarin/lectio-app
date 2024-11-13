import 'package:flutter_riverpod/flutter_riverpod.dart';

// Un estado simple para el ejemplo
final lectioProvider = StateProvider<List<String>>((ref) => []);