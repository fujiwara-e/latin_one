import 'package:flutter/material.dart';
import 'package:latin_one/screens/home.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latin_one/navigator/bottom_navigator.dart';
import 'package:latin_one/navigator/tab_navigator.dart';

int selectedIndex = 0;

class Screen extends StatefulWidget {
  const Screen({super.key, required this.title});

  final String title;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  TabItem _currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.shops: GlobalKey<NavigatorState>(),
    TabItem.order: GlobalKey<NavigatorState>(),
  };

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void checkTabItem() {
    if (_currentTab == TabItem.home) {
      setState(() {
        canPopValue = true;
      });
    } else {
      canPopValue = false;
    }
  }

  bool canPopValue = true;

  @override
  Widget build(BuildContext context) {
    checkTabItem();
    return PopScope(
        canPop: canPopValue,
        onPopInvoked: (bool didpop) {
          onSelect(TabItem.home);
          if (homeIndex == 1) {
            // Navigator.pop;
          }
        },
        child: Scaffold(
            body: Stack(children: <Widget>[
              _buildTabItem(TabItem.home, '/home'),
              _buildTabItem(TabItem.shops, '/shops'),
              _buildTabItem(TabItem.order, '/order')
            ]),
            bottomNavigationBar:
                BottomNavigation(currentTab: _currentTab, onSelect: onSelect)));
  }

  Widget _buildTabItem(
    TabItem tabItem,
    String root,
  ) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigationKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        routerName: root,
      ),
    );
  }

  void onSelect(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }
}
