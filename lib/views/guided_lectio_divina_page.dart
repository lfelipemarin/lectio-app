import 'package:flutter/material.dart';

class GuidedLectioDivinaPage extends StatefulWidget {
  const GuidedLectioDivinaPage({super.key});

  @override
  _GuidedLectioDivinaPageState createState() => _GuidedLectioDivinaPageState();
}

class _GuidedLectioDivinaPageState extends State<GuidedLectioDivinaPage> {
  int _currentStage = 0;
  final TextEditingController _sacredTextController = TextEditingController();
  final TextEditingController _meditationNotesController =
      TextEditingController();
  final TextEditingController _prayerController = TextEditingController();
  final TextEditingController _contemplationController =
      TextEditingController();
  final TextEditingController _commitmentController = TextEditingController();

  final List<String> _stages = [
    'Lectura',
    'Meditación',
    'Oración',
    'Contemplación',
    'Compromiso',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lectio Divina - ${_stages[_currentStage]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  _buildStageContent(), // Construye el contenido según la etapa
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (_currentStage < _stages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStage++;
                      });
                    },
                    child: const Text('Siguiente'),
                  ),
                if (_currentStage == _stages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      // Acción final para guardar todo o procesar los datos
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lectio Divina finalizada.')),
                      );
                    },
                    child: const Text('Finalizar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    switch (_currentStage) {
      case 0: // Lectura
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Texto de la Biblia:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                '- Escribe o pega un pasaje textual de las Sagradas Escrituras'),
            const SizedBox(height: 16),
            TextField(
              controller: _sacredTextController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe o pega un pedazo del Texto Sagrado aquí...',
              ),
            ),
          ],
        );
      case 1: // Meditación
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preguntas reflexivas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('- ¿Qué palabra o frase resuena más contigo?'),
            const Text('- ¿Qué te está diciendo Dios en este pasaje?'),
            const SizedBox(height: 16),
            TextField(
              controller: _meditationNotesController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tus reflexiones aquí...',
              ),
            ),
          ],
        );
      case 2: // Oración
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guía para la oración:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                'Habla con Dios en tus propias palabras sobre lo que te ha inspirado este pasaje.'),
            const SizedBox(height: 16),
            TextField(
              controller: _prayerController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu oración aquí...',
              ),
            ),
          ],
        );
      case 3: // Contemplación
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reflexión en silencio:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                'Pasa unos momentos en silencio ante la presencia de Dios, dejando que el pasaje transforme tu corazón.'),
            const SizedBox(height: 16),
            TextField(
              controller: _contemplationController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tus pensamientos finales aquí...',
              ),
            ),
          ],
        );
      case 4: // Compromiso
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compromiso práctico:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                'Escribe cómo vas a aplicar este mensaje en tu vida diaria.'),
            const SizedBox(height: 16),
            TextField(
              controller: _commitmentController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe tu compromiso aquí...',
              ),
            ),
          ],
        );
      default:
        return const Text('Etapa desconocida.');
    }
  }

  @override
  void dispose() {
    _sacredTextController.dispose();
    _meditationNotesController.dispose();
    _prayerController.dispose();
    _contemplationController.dispose();
    _commitmentController.dispose();
    super.dispose();
  }
}
