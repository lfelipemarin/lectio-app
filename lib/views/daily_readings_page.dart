import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/daily_readings_viewmodel.dart';

class DailyReadingsPage extends ConsumerStatefulWidget {
  final void Function(String) onNavigateToLectioGuiada;

  const DailyReadingsPage({super.key, required this.onNavigateToLectioGuiada});

  @override
  DailyReadingsPageState createState() => DailyReadingsPageState();
}

class DailyReadingsPageState extends ConsumerState<DailyReadingsPage> {
  String? _selectedText;
  String _selectedDate = DateTime.now().toIso8601String().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    final dailyReadings = ref.watch(dailyReadingsProvider(_selectedDate));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  _selectDate(context);
                },
                child: const Text('Seleccionar fecha'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Evangelio del día: $_selectedDate',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            dailyReadings.when(
              data: (data) {
                final readings = data['readings'] ?? [];
                final commentary = data['commentary'] != null
                    ? {
                        'title': data['commentary']['title'] ?? 'Sin título',
                        'description': data['commentary']['description'] ??
                            'Sin descripción',
                        'author':
                            data['commentary']['author'] ?? 'Autor desconocido',
                        'source': data['commentary']['source'] ?? 'Sin fuente',
                      }
                    : null;

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: readings.length,
                      itemBuilder: (context, index) {
                        final reading = readings[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              reading['book'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reading['reference']),
                                const SizedBox(height: 4),
                                Listener(
                                  onPointerUp: (event) {
                                    if (_selectedText != null &&
                                        _selectedText!.isNotEmpty) {
                                      _showContextMenu(context, _selectedText!);
                                      setState(() {
                                        _selectedText =
                                            null; // Reset selected text
                                      });
                                    }
                                  },
                                  child: SelectableText(
                                    reading['text'],
                                    onSelectionChanged: (selection, cause) {
                                      final selectedText =
                                          selection.textInside(reading['text']);
                                      if (cause ==
                                              SelectionChangedCause.longPress ||
                                          cause == SelectionChangedCause.drag) {
                                        setState(() {
                                          _selectedText = selectedText;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
                                  commentary['description'],
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
                                  'Fuente: ${commentary['source']}',
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

  void _showContextMenu(BuildContext context, String selectedText) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text("Enviar a Lectio Guiada"),
                onTap: () {
                  Navigator.pop(context);
                  widget.onNavigateToLectioGuiada(selectedText);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copiar texto"),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: selectedText));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Texto copiado al portapapeles')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }
}
