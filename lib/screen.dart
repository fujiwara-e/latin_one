import 'package:flutter/material.dart';
import 'package:latin_one/screens/home.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latin_one/navigator/bottom_navigator.dart';
import 'package:latin_one/navigator/tab_navigator.dart';

int selectedIndex = 0;
bool canPopValue = true;

class Screen extends StatefulWidget {
  const Screen({super.key, required this.title});

  final String title;

  @override
  State<Screen> createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  int _current_index = 0;
  TabItem _currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.shops: GlobalKey<NavigatorState>(),
    TabItem.order: GlobalKey<NavigatorState>(),
  };

  // debug
  void printNavigationKeys() {
    print("Home Navigator Key: ${_navigatorKeys[TabItem.home]?.currentState}");
    print(
        "Shops Navigator Key: ${_navigatorKeys[TabItem.shops]?.currentState}");
    print(
        "Order Navigator Key: ${_navigatorKeys[TabItem.order]?.currentState}");
  }

  void checkTabItem() {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    print("current route is $currentRoute");

    if (currentRoute == null) {
      canPopValue = false;
      print("ModalRoute is NULL!!!");
    } else if (_currentTab == TabItem.home) {
      setState(() {
        canPopValue = true;
      });
    } else {
      canPopValue = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkTabItem();
    return PopScope(
        canPop: canPopValue,
        onPopInvoked: (bool didpop) {
          onSelect(TabItem.home);
        },
        child: Scaffold(
            body: Stack(children: <Widget>[
              _buildTabItem(TabItem.home, '/home'),
              _buildTabItem(TabItem.shops, '/shops'),
              _buildTabItem(TabItem.order, '/order')
            ]),
            bottomNavigationBar: BottomNavigation(
              currentTab: _currentTab,
              onSelect: onSelect,
              currentIndex: _current_index,
            )));
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
    if (_currentTab == TabItem.home)
      _navigatorKeys[_currentTab]!
          .currentState!
          .popUntil((route) => route.isFirst);
    setState(() {
      _currentTab = tabItem;
      _current_index = tabItem.index;
    });
  }
}
