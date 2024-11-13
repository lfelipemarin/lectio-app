import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/lectio_viewmodel.dart';
import 'lectio_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener la lista de lectios del provider
    final lectios = ref.watch(lectioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lectio Divina'),
      ),
      body: lectios.isEmpty
          ? const Center(
        child: Text(
          'No tienes lectios guardadas aún',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: lectios.length,
        itemBuilder: (context, index) {
          final lectio = lectios[index];
          return ListTile(
            title: Text(lectio),
            onTap: () {
              // Navega a los detalles de la lectio seleccionada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LectioDetailPage(lectio: lectio),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Agrega una nueva lectio (por ahora solo una prueba)
          ref.read(lectioProvider.notifier).state = [...lectios, 'Nueva Lectio'];
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
