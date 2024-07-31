import 'package:flutter/material.dart';
import 'package:latin_one/screen.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.title});

  final String title;

  @override
  State<OrderPage> createState() => _OrderPageState();

}

class _OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didpop){selectedIndex = 0;},
        child: Scaffold(
          body:Text('Order'),
        )
    );
  }
}