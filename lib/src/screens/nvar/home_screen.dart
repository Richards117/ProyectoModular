import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/nvar/recomend.dart';
import 'package:flutter_application_app/src/screens/nvar/top_screen.dart';
import 'package:flutter_application_app/src/screens/places/inicio_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationModel(),
      child: const Scaffold(
        body: Pages(),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<NavigationModel>(context);

    return Container(
      decoration: const BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: BottomNavigationBar(
        selectedItemColor: Colors.black87,
        type: BottomNavigationBarType.shifting,
        onTap: (i) => navigationModel.currentPage = i,
        elevation: 2,
        currentIndex: navigationModel.currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend_outlined),
            activeIcon: Icon(Icons.recommend),
            label: 'Recs',
            backgroundColor: Color.fromRGBO(8, 140, 163, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.house),
            label: 'Inicio',
            backgroundColor: Color.fromRGBO(26, 150, 156, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumbs_up_down_sharp),
            activeIcon: Icon(Icons.thumbs_up_down_outlined),
            label: 'Top',
            backgroundColor: Color.fromRGBO(8, 140, 163, 1),
          ),
        ],
      ),
    );
  }
}

class Pages extends StatelessWidget {
  const Pages({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<NavigationModel>(context);

    return PageView(
      controller: navigationModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        Recommendations(),
        FoursquarePlaces(),
        TopScreen(),
      ],
    );
  }
}

class NavigationModel with ChangeNotifier {
  int _currentPage = 1;
  final PageController _pageController = PageController(initialPage: 1);

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);

    notifyListeners();
  }

  PageController get pageController => _pageController;
}
