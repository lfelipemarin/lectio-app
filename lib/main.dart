import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/providers/theme_provider.dart';
import 'package:lectio_app/views/authentication_page.dart';
import 'package:lectio_app/views/authenticated_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Lectio Divina App',
      themeMode: themeMode, // Dynamically change theme
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: const AuthChecker(), // Página que controla la autenticación
    );
  }
}

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
