import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/screens/item.dart';

const tabTitle = <TabItem, String>{
  TabItem.home: 'Home',
  TabItem.shops: 'Shops',
  TabItem.order: 'Order',
};
final tabIcon = <TabItem, Widget>{
  TabItem.home: Image.asset(
    'assets/images/home.png',
    width: 25,
    height: 25,
  ),
  TabItem.shops: Image.asset(
    'assets/images/store.png',
    width: 25,
    height: 25,
  ),
  TabItem.order: Image.asset(
    'assets/images/coffee.png',
    width: 25,
    height: 25,
  ),
};

class BottomNavigation extends StatefulWidget {
  BottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelect,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelect;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  int current_index = 0;

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current_index,
      items: <BottomNavigationBarItem>[
        bottomItem(
          context,
          tabItem: TabItem.home,
        ),
        bottomItem(
          context,
          tabItem: TabItem.shops,
        ),
        bottomItem(
          context,
          tabItem: TabItem.order,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        widget.onSelect(TabItem.values[index]);
        setState(() {
          current_index = index;
        });
        print(current_index);
      },
    );
  }

  BottomNavigationBarItem bottomItem(
    BuildContext context, {
    TabItem? tabItem,
  }) {
    return BottomNavigationBarItem(
      icon: tabIcon[tabItem]!,
      label: tabTitle[tabItem]!,
    );
  }
}
