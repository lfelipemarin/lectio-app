import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/views/daily_readings_page.dart';
import 'package:lectio_app/views/guided_lectio_divina_page.dart';
import 'package:lectio_app/views/lectios/lectio_list_page.dart';
import 'package:lectio_app/widgets/header_bar.dart';

class AuthenticatedPage extends ConsumerStatefulWidget {
  const AuthenticatedPage({super.key});

  @override
  AuthenticatedPageState createState() => AuthenticatedPageState();
}

class AuthenticatedPageState extends ConsumerState<AuthenticatedPage> {
  int _selectedIndex = 0;

  // Las pantallas que se mostrarán en cada pestaña
  final List<Widget> _pages = [
    const DailyReadingsPage(),
    const GuidedLectioDivinaPage(),
    const LectioListPage()
    // TODO: Implement daily saints page
    // const SaintsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the authenticated user from the provider
    final user = ref.watch(authUserProvider);

    return Scaffold(
      appBar: HeaderBar(
        profileImageUrl: user.value?.photoURL, // Pass profile image URL
        userName: user.value?.displayName ?? 'User', // Pass the user's name
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Lecturas del Día',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Lectio Guiada',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Lectios Guardadas',
          ),
          // TODO: Implement daily saints page
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Santos del Día',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
