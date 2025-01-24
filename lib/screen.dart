import 'package:flutter/material.dart';
import 'package:latin_one/screens/home.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latin_one/navigator/bottom_navigator.dart';
import 'package:latin_one/navigator/tab_navigator.dart';
import 'package:latin_one/entities/catalog.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latin_one/network/connectivity.dart';
import 'package:latin_one/navigator/router.dart';

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPopValue,
        onPopInvoked: (bool didpop) {
          onSelect(0);
        },
        child: Scaffold(
          body: MaterialApp.router(
            routerConfig: goRouter,
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              onSelect(index);
            },
            indicatorColor: Colors.yellow[800],
            selectedIndex: _current_index,
            destinations: <Widget>[
              NavigationDestination(
                icon: Image.asset(
                  'assets/images/home.png',
                  width: 25,
                  height: 25,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/images/store.png',
                  width: 25,
                  height: 25,
                ),
                label: 'Shops',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/images/coffee.png',
                  width: 25,
                  height: 25,
                ),
                label: 'Order',
              )
            ],
          ),
        ));
  }

  void onSelect(int index) {
    setState(() {
      _current_index = index;
    });
    switch (index) {
      case 0:
        goRouter.go('/');
        break;
      case 1:
        goRouter.go('/Shops');
        break;
      case 2:
        goRouter.go('/Order');
    }
  }

  // void onSelect(int index) {
  //   if (_currentTab == TabItem.home) {
  //     if (_navigatorKeys[_currentTab]?.currentState != null) {
  //       _navigatorKeys[_currentTab]!
  //           .currentState!
  //           .popUntil((route) => route.isFirst);
  //     }
  //   }
  //   setState(() {
  //     _currentTab = tabItem;
  //     _current_index = tabItem.index;
  //   });
  // }
}
