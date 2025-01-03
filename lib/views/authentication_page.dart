import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lectio_app/widgets/donate_button.dart';

import '../ads/banner_ad_widget.dart';
import 'forgot_password_page.dart';

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
  // Create a GlobalKey to manage the form's state
  final _formKey = GlobalKey<FormState>();

  // Iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

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
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Usuario no encontrado. Verifica tu correo.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta. Inténtalo de nuevo.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        log("Error de inicio de sesión con Email: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error: $e')),
        );
      }
    }
  }

  // Registrar con Email y Contraseña
  Future<void> _registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Bienvenido!')),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'El correo ya está en uso. Usa uno diferente.';
        } else if (e.code == 'weak-password') {
          errorMessage =
              'La contraseña es demasiado débil. Usa una más segura.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Correo electrónico inválido. Inténtalo de nuevo.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        log("Error de registro con Email: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autenticación")),
      body: Column(
        children: [
          // Banner Ad Widget at the top
          const BannerAdWidget(
              adUnitId: 'ca-app-pub-8656992370512809/1954841426'),

          // Make the content scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Correo electrónico'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El correo electrónico no puede estar vacío.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Contraseña'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña no puede estar vacía.';
                          }
                          return null;
                        },
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          );
                        },
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                      const DonateButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
