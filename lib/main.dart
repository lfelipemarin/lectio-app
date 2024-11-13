import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/views/daily_readings_page.dart';
import 'package:lectio_app/views/home_page.dart';
import 'package:lectio_app/views/saints_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lectio Divina App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const _MainPage(),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  int _selectedIndex = 0;

  // Las pantallas que se mostrarán en cada pestaña
  final List<Widget> _pages = [
    const DailyReadingsPage(),
    const HomePage(),
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
            icon: Icon(Icons.book),
            label: 'Lectios',
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
