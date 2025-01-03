import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/ads/banner_ad_widget.dart';
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

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DailyReadingsPage(
        onNavigateToLectioGuiada: _navigateToGuidedLectioDivina,
      ),
      const GuidedLectioDivinaPage(initialText: ""),
      const LectioListPage(),
    ];
  }

  void _onPopInvokedWithResult(bool canPop, dynamic result) {
    final navigatorState = _navigatorKeys[_currentIndex].currentState;

    if (navigatorState != null && navigatorState.canPop()) {
      navigatorState.pop();
    } else if (_currentIndex > 0) {
      setState(() {
        _currentIndex = 0; // Switch to the default tab
      });
    } else {
      // Exit the app or show a confirmation dialog
      SystemNavigator.pop();
    }
  }

  // This method will change the index of the selected tab
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _navigateToGuidedLectioDivina(String text) {
    _navigatorKeys[1].currentState?.pushReplacement(MaterialPageRoute(
        builder: (_) => GuidedLectioDivinaPage(initialText: text)));

    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authUserProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        appBar: HeaderBar(
          profileImageUrl: user.value?.photoURL,
          userName: user.value?.displayName ?? 'User',
        ),
        body: Column(
          children: [
            const BannerAdWidget(
                adUnitId:
                    'ca-app-pub-8656992370512809/5970868822'), // The banner ad at the top
            Expanded(
              child: Stack(
                children: [
                  for (int i = 0; i < _pages.length; i++)
                    Offstage(
                      offstage: _currentIndex != i,
                      child: Navigator(
                        key: _navigatorKeys[i],
                        onGenerateRoute: (routeSettings) {
                          return MaterialPageRoute(builder: (_) => _pages[i]);
                        },
                      ),
                    ),
                ],
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
