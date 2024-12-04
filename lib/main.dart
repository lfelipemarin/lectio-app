import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lectio_app/providers/theme_provider.dart';
import 'package:lectio_app/views/auth_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
