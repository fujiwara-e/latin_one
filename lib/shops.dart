import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key, required this.title});

  final String title;

  @override
  State<ShopsPage> createState() => _ShopsPageState();

}

class _ShopsPageState extends State<ShopsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(index){
      case 0:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 1:
        break;
      case 2:
        Navigator.popAndPushNamed(context,"/order");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:Text('Shops'),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/home.svg',semanticsLabel: 'Home', width: 25, height: 25),label: 'Home'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/store.svg',semanticsLabel: 'Shops', width: 25, height: 25), label: 'Shops'),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/coffee.svg',semanticsLabel: 'Order', width: 25, height: 25), label: 'Order'),
          ],
          type: BottomNavigationBarType.fixed,
        )
    );
  }
}