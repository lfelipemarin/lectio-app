import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/readings_service.dart'; // Adjust the path as needed

final dailyReadingsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, date) async {
  return await ReadingsService.fetchDailyReadings(date);
});
