import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/daily_readings_viewmodel.dart'; // Adjust as necessary
import 'dart:developer' as developer;

class DailyReadingsPage extends ConsumerStatefulWidget {
  const DailyReadingsPage({super.key});

  @override
  _DailyReadingsPageState createState() => _DailyReadingsPageState();
}

class _DailyReadingsPageState extends ConsumerState<DailyReadingsPage> {
  String _selectedDate = DateTime.now().toIso8601String().substring(0, 10); // Default date

  @override
  Widget build(BuildContext context) {
    // Pass the selected date to the provider
    final dailyReadings = ref.watch(dailyReadingsProvider(_selectedDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturas del Día'),
      ),
      body: SingleChildScrollView(
        // Wrap content inside SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  _selectDate(context); // Call the date selector
                },
                child: const Text('Seleccionar fecha'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Evangelio del dia: $_selectedDate', // Mostrar la fecha seleccionada
                style: const TextStyle(fontSize: 16),
              ),
            ),
            dailyReadings.when(
              data: (data) {
                final readings = data['readings'] ?? [];
                final commentary = data['commentary'] != null
                    ? {
                        'title':
                            data['commentary']['title'] ?? 'No title available',
                        'description': data['commentary']['description'] ??
                            'No description available',
                        'author':
                            data['commentary']['author'] ?? 'Unknown author',
                        'source': data['commentary']['source'] ??
                            'No source available',
                      }
                    : null;

                return Column(
                  children: [
                    // List of readings
                    ListView.builder(
                      shrinkWrap:
                          true, // Ensures the ListView doesn't take up all space
                      physics:
                          const NeverScrollableScrollPhysics(), // Disables scrolling of ListView
                      itemCount: readings.length,
                      itemBuilder: (context, index) {
                        final reading = readings[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              reading['book'], // Book title
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reading['reference']), // Reference
                                const SizedBox(height: 4),
                                Text(reading['text']), // Reading text
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Commentary after the list
                    if (commentary != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commentary['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  commentary['description'].replaceAll(
                                      RegExp(r'^[ \t]+', multiLine: true), ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Autor: ${commentary['author']}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tomado de: ${commentary['source']}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  // Method to select the date using showDatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }
}
