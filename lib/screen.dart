import 'package:flutter/material.dart';
import 'package:latin_one/screens/home.dart';
import 'package:latin_one/screens/order.dart';
import 'package:latin_one/screens/shops.dart';

int selectedIndex = 0;

class Screen extends StatefulWidget {
  const Screen({super.key, required this.title});

  final String title;

  @override
  State<Screen> createState() => _ScreenState();

}

class _ScreenState extends State<Screen> {

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens.addAll([
      MyHomePage(onChangeIndex: _onItemTapped),
      ShopsPage(onChangeIndex: _onItemTapped),
      OrderPage(onChangeIndex:_onItemTapped),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:screens[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Image.asset('assets/images/home.png', width: 25, height: 25,),label: 'Home'),
            BottomNavigationBarItem(icon: Image.asset('assets/images/store.png', width: 25, height: 25,), label: 'Shops'),
            BottomNavigationBarItem(icon: Image.asset('assets/images/coffee.png', width: 25, height: 25,), label: 'Order'),
          ],
          type: BottomNavigationBarType.fixed,
        )
    );
  }
}