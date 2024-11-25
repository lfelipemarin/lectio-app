import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectio_app/models/lectio_model.dart';
import 'package:lectio_app/providers/auth_provider.dart';

import '../providers/lectio_provider.dart';

class LectioDetailPage extends ConsumerStatefulWidget {
  final LectioModel lectio;

  const LectioDetailPage({super.key, required this.lectio});

  @override
  ConsumerState<LectioDetailPage> createState() => _LectioDetailPageState();
}

class _LectioDetailPageState extends ConsumerState<LectioDetailPage> {
  bool _isEditing = false;
  late TextEditingController _lectioController;
  late TextEditingController _meditatioController;
  late TextEditingController _oratioController;
  late TextEditingController _actioController;

  @override
  void initState() {
    super.initState();
    _lectioController = TextEditingController(text: widget.lectio.lectio);
    _meditatioController = TextEditingController(text: widget.lectio.meditatio);
    _oratioController = TextEditingController(text: widget.lectio.oratio);
    _actioController = TextEditingController(text: widget.lectio.actio);
  }

  @override
  void dispose() {
    _lectioController.dispose();
    _meditatioController.dispose();
    _oratioController.dispose();
    _actioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(String userEmail) async {
    final updatedLectio = widget.lectio.copyWith(
      lectio: _lectioController.text,
      meditatio: _meditatioController.text,
      oratio: _oratioController.text,
      actio: _actioController.text,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail) // Usa el email como identificador del documento
          .collection('lectios')
          .doc(widget.lectio.documentSnapshot?.id) // Usa el ID del documento existente
          .update(updatedLectio.toFirestore());

      // Actualiza el estado global
      ref.read(lectioProvider.notifier).updateLectio(updatedLectio);

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lectio actualizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los cambios: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authUserProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                authState.when(
                  data: (user) {
                    if (user != null) {
                      _saveChanges(user.email ?? "unknown");
                    }
                  },
                  loading: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cargando usuario...')),
                  ),
                  error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  ),
                );
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEditableField(
              label: 'Lectio',
              controller: _lectioController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: 'Meditatio',
              controller: _meditatioController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: 'Oratio',
              controller: _oratioController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: 'Actio',
              controller: _actioController,
              isEditing: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        isEditing
            ? TextFormField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
            : Text(
          controller.text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
