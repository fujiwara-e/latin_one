import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latin_one/screens/item.dart';


const tabTitle = <TabItem, String>{
  TabItem.home: 'Home',
  TabItem.shops: 'Shops',
  TabItem.order: 'Order',
};
final tabIcon = <TabItem, Widget>{
  TabItem.home:  Image.asset('assets/images/home.png', width: 25, height: 25,),
  TabItem.shops: Image.asset('assets/images/store.png', width: 25, height: 25,),
  TabItem.order: Image.asset('assets/images/coffee.png', width: 25, height: 25,),
};

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelect,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelect;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
        onSelect(TabItem.values[index]);
      },
    );
  }

  BottomNavigationBarItem bottomItem(
      BuildContext context, {
        TabItem? tabItem,
      }) {
    final color = currentTab == tabItem ? Colors.blue : Colors.black26;
    return BottomNavigationBarItem(
      icon: tabIcon[tabItem]!,
      label: tabTitle[tabItem]!,);
  }
}