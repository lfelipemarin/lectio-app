
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/lectio_provider.dart';
import '../lectio_detail_page.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class LectioListPage extends ConsumerStatefulWidget {
  const LectioListPage({super.key});

  @override
  _LectioListPageState createState() => _LectioListPageState();
}

class _LectioListPageState extends ConsumerState<LectioListPage> {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Load the lectios when the page is entered
    Future.delayed(const Duration(milliseconds: 300), () {
      ref.read(authUserProvider).when(
        data: (user) {
          if (user != null) {
            ref.read(lectioProvider.notifier).loadLectios(user);
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          // Handle any error
        },
      );
    });
  }

  // Function to open the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      final formattedDate = '${pickedDate.toLocal()}'.split(' ')[0];
      setState(() {
        _selectedDate = pickedDate;
        _searchController.text = formattedDate;
      });
      // Trigger the filter in your provider
      ref.read(lectioProvider.notifier).setFilter(formattedDate);
    }
  }

// Function to clear the selected date
  void clearDate() {
    setState(() {
      _selectedDate = null;
      _searchController.text = "";
    });
    // Reset the filter in your provider
    ref.read(lectioProvider.notifier).setFilter(_searchController.text);
  }



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lectioProvider);
    final authUser = ref.watch(authUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lectios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por fecha de creación',
                border: const OutlineInputBorder(),
                hintText: 'Seleccione una fecha',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            if (_searchController.text.isNotEmpty)
              ElevatedButton(
                onPressed: clearDate,
                child: const Text('Limpiar fecha'),
              ),
            Expanded(
              child: authUser.when(
                data: (user) {
                  if (state.isLoading && state.lectios.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: state.lectios.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.lectios.length) {
                        return state.hasMore
                            ? ElevatedButton(
                          onPressed: () => ref.read(lectioProvider.notifier).loadMoreLectios(user),
                          child: const Text('Cargar más'),
                        )
                            : const Center(child: Text('No hay más lectios.'));
                      }
                      final lectio = state.lectios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(lectio.lectio),
                          subtitle: Text('Creado en: ${lectio.createdAt}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LectioDetailPage(lectio: lectio),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
