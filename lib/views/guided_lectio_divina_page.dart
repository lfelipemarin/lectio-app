
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/services/lectio_service.dart';
import 'package:lectio_app/providers/auth_provider.dart';
import 'package:lectio_app/views/authenticated_page.dart';

class GuidedLectioDivinaPage extends ConsumerStatefulWidget {
  final String initialText;

  const GuidedLectioDivinaPage({super.key, required this.initialText});

  @override
  GuidedLectioDivinaPageState createState() => GuidedLectioDivinaPageState();
}

class GuidedLectioDivinaPageState
    extends ConsumerState<GuidedLectioDivinaPage> {
  final LectioService _lectioService = LectioService();

  int _currentStage = 0;
  late String _currentText;

  late TextEditingController _actioController;
  late TextEditingController _lectioController;
  late TextEditingController _meditationNotesController;
  late TextEditingController _oratioController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con texto inicial
    _currentText = widget.initialText;
    _actioController = TextEditingController();
    _lectioController = TextEditingController(text: widget.initialText ?? '');
    _meditationNotesController = TextEditingController();
    _oratioController = TextEditingController();
  }

  void updateText(String text) {
    setState(() {
      _currentText = text;
    });
    _lectioController.text = text;
  }

  final bool _completedActio = false;
  bool _reminder = false;

  void _saveLectio(User user) async {
    try {
      await _lectioService.saveLectio(
        userId: user.email,
        actio: _actioController.text,
        completedActio: _completedActio,
        createdAt: DateTime.now().toIso8601String(),
        lectio: _lectioController.text,
        meditatio: _meditationNotesController.text,
        oratio: _oratioController.text,
        reminder: _reminder,
        updatedAt: DateTime.now().toIso8601String(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lectio guardada exitosamente')),
      );

      // Schedule navigation after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticatedPage()),
        ); // or Navigator.pushReplacement(...) if needed
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la lectio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar el estado del usuario autenticado
    final authUser = ref.watch(authUserProvider);

    return Scaffold(
      body: authUser.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('No estás autenticado'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildStageContent()),
                Row(
                  children: [
                    if (_currentStage > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentStage--;
                          });
                        },
                        child: const Text('Anterior'),
                      ),
                    const Spacer(),
                    // Este espacio empuja el siguiente botón hacia la derecha
                    if (_currentStage < 3)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentStage++;
                          });
                        },
                        child: const Text('Siguiente'),
                      ),
                    if (_currentStage == 3)
                      ElevatedButton(
                        onPressed: () => _saveLectio(user),
                        child: const Text('Guardar Lectio'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStageContent() {
    switch (_currentStage) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Texto de la Biblia:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lectioController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe o pega un pasaje...',
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meditación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _meditationNotesController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tus reflexiones...',
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Oración:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _oratioController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu oración...',
              ),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actio:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _actioController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu compromiso...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('¿Recordatorio?'),
                Checkbox(
                  value: _reminder,
                  onChanged: (value) {
                    setState(() {
                      _reminder = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _lectioController.dispose();
    _meditationNotesController.dispose();
    _oratioController.dispose();
    _actioController.dispose();
    super.dispose();
  }
}
