import 'package:flutter/material.dart';

class DonateButton extends StatelessWidget {
  const DonateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showDonateModal(context),
      icon: const Icon(Icons.volunteer_activism),
      label: const Text('Donar'),
    );
  }

  void _showDonateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image at the top
              Image.asset(
                'assets/images/donacion_qr.jpeg',
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              // Bank account information
              const Text(
                '¡Gracias por tu apoyo!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Puedes realizar tu donación a través de los siguientes datos bancarios:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Banco: Banco Ejemplo\nCuenta: 1234567890\nTitular: Lectio Divina App\nSWIFT: ABCD1234',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
