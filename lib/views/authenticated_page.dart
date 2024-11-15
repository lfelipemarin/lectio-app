import 'package:flutter/material.dart';
import 'package:lectio_app/views/daily_readings_page.dart';
import 'package:lectio_app/views/guided_lectio_divina_page.dart';
import 'package:lectio_app/views/saints_page.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({Key? key}) : super(key: key);

  @override
  _AuthenticatedPageState createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  int _selectedIndex = 0;

  // Las pantallas que se mostrarán en cada pestaña
  final List<Widget> _pages = [
    const DailyReadingsPage(),
    const GuidedLectioDivinaPage(),
    const SaintsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.person),
            label: 'Santos del Día',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
