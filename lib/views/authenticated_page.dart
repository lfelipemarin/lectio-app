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
  int _currentIndex = 0;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    const DailyReadingsPage(),
    const GuidedLectioDivinaPage(),
    const LectioListPage(),
  ];

  // List of GlobalKeys for each Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // This method will change the index of the selected tab
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // This will handle the back button functionality for each Navigator
  Future<bool> _onWillPop() async {
    // Check if the current tab's Navigator can pop a route
    if (await _navigatorKeys[_currentIndex].currentState!.maybePop()) {
      return false; // Don't exit the app, pop the current page
    }

    // If no route can be popped, switch to the previous tab (if possible)
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1;
      });
      return false; // Prevent the app from exiting
    }

    // If on the first tab, confirm exit
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authUserProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: HeaderBar(
          profileImageUrl: user.value?.photoURL,
          userName: user.value?.displayName ?? 'User',
        ),
        body: Stack(
          children: <Widget>[
            // First Navigator (Tab 1)
            Offstage(
              offstage: _currentIndex != 0,
              child: Navigator(
                key: _navigatorKeys[0],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => _pages[0]);
                },
              ),
            ),
            // Second Navigator (Tab 2)
            Offstage(
              offstage: _currentIndex != 1,
              child: Navigator(
                key: _navigatorKeys[1],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => _pages[1]);
                },
              ),
            ),
            // Third Navigator (Tab 3)
            Offstage(
              offstage: _currentIndex != 2,
              child: Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => _pages[2]);
                },
              ),
            ),
          ],
        ),
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
              icon: Icon(Icons.bookmark),
              label: 'Lectios Guardadas',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
