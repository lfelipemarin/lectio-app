import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authenticated_page.dart';
import 'authentication_page.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Escucha el estado de autenticación
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error de autenticación'));
        } else if (snapshot.hasData) {
          return const AuthenticatedPage(); // Si el usuario está logueado, mostramos la página de navegación
        } else {
          return const AuthenticationPage(); // Si no está logueado, mostramos la página de inicio de sesión
        }
      },
    );
  }
}