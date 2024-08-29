import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/screens/home.dart';
import 'package:latin_one/screens/item.dart';
import 'package:latin_one/screens/order.dart';
import 'package:latin_one/screens/shops.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.tabItem,
    required this.routerName,
    required this.navigationKey,
  }) : super(key: key);

  final TabItem tabItem;
  final String routerName;
  final GlobalKey<NavigatorState> navigationKey;

  Map<String, Widget Function(BuildContext)> _routerBuilder(
          BuildContext context) =>
      {
        '/home': (context) => const HomePage(),
        '/shops': (context) => const ShopsPage(),
        '/order': (context) => const OrderPage(),
      };

  @override
  Widget build(BuildContext context) {
    final routerBuilder = _routerBuilder(context);

    return Navigator(
      key: navigationKey,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return routerBuilder[routerName]!(context);
          },
        );
      },
    );
  }
}
