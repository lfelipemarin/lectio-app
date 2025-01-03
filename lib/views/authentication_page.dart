import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../ads/banner_ad_widget.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  AuthenticationPageState createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Autenticación con Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      // Aquí puedes navegar a la pantalla principal después de un login exitoso
    } catch (e) {
      log("Error de inicio de sesión con Google: $e");
    }
  }

  // Iniciar sesión con Email y Contraseña
  Future<void> _signInWithEmail() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Aquí puedes navegar a la pantalla principal después de un login exitoso
    } catch (e) {
      log("Error de inicio de sesión con Email: $e");
    }
  }

  // Registrar con Email y Contraseña
  Future<void> _registerWithEmail() async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Aquí puedes navegar a la pantalla principal después de un registro exitoso
    } catch (e) {
      log("Error de registro con Email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autenticación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BannerAdWidget(adUnitId: 'ca-app-pub-8656992370512809/1954841426'), // The banner ad at the top
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: const Text('Iniciar sesión con correo'),
            ),
            ElevatedButton(
              onPressed: _registerWithEmail,
              child: const Text('Registrar con correo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Iniciar sesión con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
