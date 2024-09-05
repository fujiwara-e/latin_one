import 'package:flutter/material.dart';
import 'package:latin_one/entities/cart.dart';
import '../config/size_config.dart';
import '../screens/item.dart';

import 'package:provider/provider.dart';
import 'package:latin_one/screens/product.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selected_store = 0;

  void _onItemTapped(int id) {
    setState(() {
      selected_store = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = context.read<CartModel>();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: SizeConfig.blockSizeVertical * 8,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Order",
                    style: TextStyle(
                      fontSize: SizeConfig.TitleSize,
                      color: Colors.black,
                      fontFamily: 'ozworld',
                    ),
                  )),
              titlePadding:
                  EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 20),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverFixedExtentList(
            itemExtent: SizeConfig.blockSizeVertical * 10 + 2,
            delegate: SliverChildListDelegate(
              [
                StoreItem(
                  text: 'お店を選択してください',
                  image: Image.asset(
                    'assets/images/store.png',
                    width: 20,
                    height: 20,
                  ),
                  widget: StorePage(),
                  selectstore: _onItemTapped,
                ),
                OrderItem(
                    text: '商品を選択してください',
                    image: Image.asset(
                      'assets/images/coffee.png',
                      width: 20,
                      height: 20,
                    ),
                    widget: ProductPage(),
                    selectedstore: selected_store),
              ],
            ),
          ),
          // TODO: cart に追加された商品を表示する
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.name),
              );
            },
            childCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
